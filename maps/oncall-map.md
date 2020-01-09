# 集群问题导图

## 1. 服务不可用

### 1.1 客户端报 region unavailable 错误

- region unavailable 一般是由于 region 在一段时间不可用导致（遇到 TiKV server is busy 或者发送给 TiKV 的请求由于 not leader 或者 epoch not match 被打回，或者请求 TiKV 超时等），TiDB 内部会进行 backoff 重试机制，backoff 的时间超过了一定阈值（默认 20s），就会报错给客户端，如果 backoff 在阈值内该错误对于客户端是无感知的。
- 多台 TiKV 同时 OOM 导致 region 在一定时期内没有 leader，例如 ONCALL-991
- TiKV 报 server is busy
- 多台 TiKV 启动不了导致 region 没有 leader。单台物理部署多个 TiKV 实例，一个物理机挂掉，由于 label 配置错了导致 region 没有 leader ，见 ONCALL-228
- follower apply 落后，成为 leader 之后把收到的请求以 epoch not match 理由打回，见 ONCALL-958（TiKV 内部需要优化改机制）

### 1.2 客户端报 server is busy 错误。请参考 TiKV 问题 server is busy 介绍

### 1.3 PD 异常，请查看 PD 问题

## 2. Latency 明显升高

### 2.1 短暂性的

- TiDB 执行计划不对。请参考 TiDB 执行计划不对问题。
- PD 发生异常

	- PD leader 发生切换

- 某些 TiKV 大量掉 leader

### 2.2 Latency 明显升高（持续的）

- TiKV 单线程瓶颈

	- region 过多导致单个 gRPC 线程成为瓶颈，需要开启 hibernate region 特性，见 ONCALL-612
	- 3.0 之前版本 raftstore 单线程或者 apply 单线程到达瓶颈，见 ONCALL-517

- CPU load 升高
- TiKV 写入慢

## 3. TiDB 问题

### 3.1 DDL

- 修改 decimal 字段长度报错 ERROR 1105 (HY000): unsupported modify decimal column precision 见 ONCALL-1004

### 3.2 OOM 问题

### 3.3 执行计划不对

- 统计信息不准

	- 统计信息更新不及时，例如 ONCALL-968
	- 自动收集没有生效，例如 ONCALL-933

- 非统计信息不准问题（非预期，需报 bug）

## 4. TiKV 问题

### 4.1 TiKV panic 启动不了

- sync-log = false，机器断电（符合预期，通过 tikv-ctl 恢复）
- 虚拟机部署 TiKV，kill 虚拟机/物理机关闭（符合预期，虚拟机的 fsync 不可靠）
- 其他原因（非预期，需报 bug）

### 4.2 TiKV OOM

- block-cache 配置太大，请检查 [storage.block-cache] capacity = "1GB" 参数
- coprocessor 收到大量大查询，占用太多内存
- 其他部分占用太多内存（非预期，需报 bug）

### 4.3 客户端报 server is busy 错误。通过 TiKV grafana errors 确认具体 busy 原因

- TiKV RocksDB 出现 write stall。一个 TiKV 实例有两个 RocksDB 实例，一个存储 raft 日志，位于 data/raft，一个存储真正的数据，位于data/db
- scheduler too busy

	- 写入冲突严重，latch wait 高（查看 scheduler prewrite|commit ），scheduler 写入任务堆积，导致超过了 [storage] scheduler-pending-write-threshold = "100MB" 设置的阈值
	- 写入慢导致写入堆积，正在写入的数据超过了 [storage] scheduler-pending-write-threshold = "100MB" 设置的阈值

- raftstore channel full，主要是消息的处理速度没有跟上接收消息的速度。短时间的 channel full 不会影响服务，持续出现该错误会导致 leader 切换走

	- append log 出现了 stall
	- append log 慢了
	- 瞬间收到大量消息（查看 TiKV Raft messages 面板），raftstore 没处理过来，通常情况下短时间的 channel full 不会影响服务

- TiKV coprocessor 排队，任务堆积超过了 coprocessor 线程数 * readpool.coprocessor.max-tasks-per-worker-[normal|low|high]。大量大查询导致 coprocessor 出现了堆积情况，需要确认是否有由于执行计划变化导致出现大量扫表操作。

### 4.4 某些 TiKV 大量掉 leader

- TiKV 重启了导致重新选举

	- TiKV panic，被 systemd 重新拉起（非预期，需要报 bug）
	- 被第三者 stop/kill，被 systemd 重新拉起。查看 dmesg 和 TiKV log 确认原因
	- 动态调整 THP 导致 hung 住，见 ONCALL-500

- 网络隔离导致重新选举
- TiKV grafana errors 面板 server is busy 看到 TiKV RocksDB 出现 write stall （grep Stalling RocksDB 日志查看 stall 原因，RocksDB 日志是 LOG 开头的文件，LOG 为当前日志）

	- level0 sst 太多导致 stall，添加参数 max-sub-compactions = 2/3 加快 level0 sst 往下 compact 速度，见 ONCALL-815
	- pending compaction bytes 太多，磁盘 IO 能力在业务高峰跟不上写入，调整 soft-pending-compaction-bytes-limit 参数，见 ONCALL-275；磁盘 IO 能力持续跟不上写入，建议扩容

- TiKV OOM

## 5. PD 问题

### 5.1 PD 调度问题

- 跨表空 region 无法 merge，见 ONCALL-896
- TIKV 磁盘使用 80% 容量，PD 不会进行补副本操作，miss peer 数量上升，见 ONCALL-801
- 下线 TiKV，有 region 长时间迁移不走，可能有问题，见 ONCALL-870

### 5.2 PD 异常

- range failed to find revision pair，见 ONCALL-947。3.0.8 已经 fix 改问题
- PD 选不出 leader，见 ONCALL-875。3.0.x 版本已 fix 该问题
- 其他情况，需报 bug
- PD leader 发生切换

### 5.3 grafana 显示问题

- PD role 显示 follower，见 ONCALL-1022

## 6. 生态 tools 问题

### 6.1 binlog 问题

#### 6.1.1 Kafka 相关问题

- 因为 Kafka 客户端版本设置问题，导致 Drainer 写 Kafka 报错，见 [TOOL-199](https://internal.pingcap.net/jira/browse/TOOL-199)
- 因为 binlog 太大，导致写 Kafka 报错，见 [ONCALL-789](https://internal.pingcap.net/jira/browse/ONCALL-789)

### 6.2 DM 问题

### 6.3 lightning 问题
