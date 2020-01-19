# 集群问题导图

## 1. 服务不可用

### 1.1 客户端报 region is unavailable 错误

- 1.1.1 region unavailable 一般是由于 region 在一段时间不可用导致（遇到 TiKV server is busy 或者发送给 TiKV 的请求由于 not leader 或者 epoch not match 被打回，或者请求 TiKV 超时等），TiDB 内部会进行 backoff 重试机制，backoff 的时间超过了一定阈值（默认 20s），就会报错给客户端，如果 backoff 在阈值内该错误对于客户端是无感知的。
- 1.1.2 多台 TiKV 同时 OOM 导致 region 在一定时期内没有 leader，例如 ONCALL-991
- 1.1.3 TiKV 报 server is busy，超过 backoff 时间，参考 4.3。server is busy 属于内部流控机制，后续可能不计入 backoff 时间，正在改善
- 1.1.4 多台 TiKV 启动不了导致 region 没有 leader。单台物理部署多个 TiKV 实例，一个物理机挂掉，由于 label 配置错了导致 region 没有 leader ，见 ONCALL-228
- 1.1.5 follower apply 落后，成为 leader 之后把收到的请求以 epoch not match 理由打回，见 ONCALL-958（TiKV 内部需要优化改机制）

### 1.2 PD 异常，请查看 PD 问题

## 2. Latency 明显升高

### 2.1 短暂性的

- 2.1.1 TiDB 执行计划不对，请参考 3.3
- 2.1.2 PD 发生异常

	- PD leader 发生切换

- 2.1.3 某些 TiKV 大量掉 leader

### 2.2 Latency 明显升高（持续的）

- 2.2.1 TiKV 单线程瓶颈

	- region 过多导致单个 gRPC 线程成为瓶颈，需要开启 hibernate region 特性，见 ONCALL-612
	- 3.0 之前版本 raftstore 单线程或者 apply 单线程到达瓶颈，见 ONCALL-517

- 2.2.2 CPU load 升高
- 2.2.3 TiKV 写入慢，请参考 4.5
- 2.2.4 TiDB 执行计划不对，请参考 3.3

## 3. TiDB 问题

### 3.1 DDL

- 修改 decimal 字段长度报错 ERROR 1105 (HY000): unsupported modify decimal column precision 见 ONCALL-1004

### 3.2 OOM 问题

- 现象

	- 客户端：客户端收到 tidb-server 报错 "ERROR 2013 (HY000): Lost connection to MySQL server during query"
	- 日志

		- `dmesg -T | grep tidb-server` 结果中有事故发生附近时间点的 OOM-killer 的日志
		-  tidb.log 中可以 grep 到事故发生后附近时间的 "Welcome to TiDB" 的日志（即 tidb-server 发生重启） 
		-  tidb_stderr.log 中能 grep 到 "fatal error: runtime: out of memory" 或 "cannot allocate memory" 
		-  v2.1.8 及其之前的版本，tidb_stderr.log 中能 grep 到 “fatal error: stack overflow”

	- 监控：tidb-server 实例所在机器可用内存迅速回升

- 定位造成 OOM 的 SQL(目前所有版本都无法完成精准定位，需要在发现 SQL 后再做进一步分析确认 OOM 是否确由该 SQL 造成)

	- >= v3.0.0 的版本, 可以在 tidb.log 中 grep “expensive_query”，该 log 会记录运行超时、或使用内存超过阈值的 SQL。
	- < v3.0.0 的版本, 通过 grep “memory exceeds quota” 定位运行时内存超限的 SQL。
	- 注：单条 SQL 内存阈值默认值为 32GB，可通过 tidb_mem_quota_query 系统变量进行设置，作用域 SESSION， 单位 Byte。也可以通过配置项热加载的方式，对配置文件中的 mem-quota-query 项进行修改，单位 Byte。

- 缓解 OOM 问题

	- 通过开启 SWAP 的方式，可以缓解由于大查询使用内存过多而造成的 OOM 问题。但该方法会在内存空间不足时，由于存在 IO 开销，因此大查询性能造成一定影响。性能回退程度受剩余内存量、读写盘速度影响。

### 3.3 执行计划不对

- 统计信息不准

	- 统计信息更新不及时，例如 ONCALL-968
	- 自动收集没有生效，例如 ONCALL-933

- 非统计信息不准问题（非预期，需报 bug）

## 4. TiKV 问题

### 4.1 TiKV panic 启动不了

- sync-log = false，机器断电之后出现 unexpected raft log index: last_index X < applied_index Y 错误。符合预期，需通过 tikv-ctl 恢复 region
- 虚拟机部署 TiKV，kill 虚拟机/物理机断电，出现 entries[X, Y]  is unavailable from storage 错误。符合预期，虚拟机的 fsync 不可靠，需通过 tikv-ctl 恢复 region
- 其他原因（非预期，需报 bug）

### 4.2 TiKV OOM

- block-cache 配置太大导致 OOM，在 TiKV grafana 选中对应的 instance 之后查看 RocksDB 的 block cache size 监控来确认是否是该问题。同时请检查 [storage.block-cache] capacity = # "1GB" 参数是否设置合理，默认情况下 TiKV 的 block-cache 设置为机器总内存的 45%，在 container 部署的时候需要显式指定该参数，因为 TiKV 获取的是物理机的内存，可能会超出 container 的内存限制。
- coprocessor 收到大量大查询，返回的数据量太大，gRPC 发送速度跟不上 coprocessor 往外吐数据的速度导致 OOM。可以通过检查 TiKV grafana coprocessor overview 的 response size 是否超过 network outbound 流量来确认是否属于这种情况。
- 其他部分占用太多内存（非预期，需报 bug）

### 4.3 客户端报 server is busy 错误。通过查看 TiKV grafana errors 监控确认具体 busy 原因。server is busy 是 TiKV 自身的流控机制，TiKV 通过这种方式告知 tidb/ti-client 当前 TiKV 的压力过大，等会再尝试

- 4.3.1 TiKV RocksDB 出现 write stall。一个 TiKV 包含两个 RocksDB 实例，一个用于存储 raft 日志，位于 data/raft，一个用于存储真正的数据，位于data/db。通过 grep "Stalling" RocksDB 日志查看 stall 的具体原因，RocksDB 日志是 LOG 开头的文件，LOG 为当前日志

	- level0 sst 太多导致 stall，添加参数 [rocksdb] max-sub-compactions = 2（或者 3） 加快 level0 sst 往下 compact 的速度，该参数的意思是将 level0->level1 的 compaction 任务最多切成max-sub-compactions 个子任务交给多线程并发执行。见 ONCALL-815
	- pending compaction bytes 太多导致 stall，磁盘 IO 能力在业务高峰跟不上写入，可以通过调大对应 cf 的 soft-pending-compaction-bytes-limit 和 hard-pending-compaction-bytes-limit 参数来缓解，例如 [rocksdb.defaultcf] soft-pending-compaction-bytes-limit = "128GB"（当 pending compaction bytes 达到该阈值，RocksDB 会放慢写入速度。默认值 64GB）hard-pending-compaction-bytes-limit = "512GB"（当 pending compaction bytes 达到该阈值，RocksDB 会 stop 写入，通常不太可能触发该情况，因为在达到 soft-pending-compaction-bytes-limit 的阈值之后会放慢写入速度。默认值 256GB），见 ONCALL-275；如果磁盘 IO 能力持续跟不上写入，建议扩容
	- memtable 太多导致 stall。该情况一般发生在瞬间写入量比较大，并且 memtable flush 到磁盘的速度比较慢的情况下。如果磁盘写入速度不能改善，并且只有业务峰值会出现这种情况，可以通过调大对应 cf 的 max-write-buffer-number 来缓解，例如 [rocksdb.defaultcf] max-write-buffer-number = 8 （默认值 5），同时请求注意在高峰期可能会占用更多的内存，因为可能存在于内存中的 memtable 会更多

- 4.3.2 scheduler too busy

	- 写入冲突严重，latch wait duration 比较高（查看 scheduler prewrite|commit  的 latch wait duration），scheduler 写入任务堆积，导致超过了 [storage] scheduler-pending-write-threshold = "100MB" 设置的阈值。TODO：通过查看 MVCC_CONFLICT_COUNTER 对应的 metric 来确认是否属于该情况
	- 写入慢导致写入堆积，该 TiKV 正在写入的数据超过了 [storage] scheduler-pending-write-threshold = "100MB" 设置的阈值。请参考 4.5

- 4.3.3 raftstore is busy，主要是消息的处理速度没有跟上接收消息的速度。短时间的 channel full 不会影响服务，长时间持续出现该错误可能会导致 leader 切换走

	- append log 遇到了 stall，参考 4.3.1
	- append log duration 比较高，导致处理消息不及时，可以参考 4.5 分析为什么 append log duration 比较高。
	- 瞬间收到大量消息（查看 TiKV Raft messages 面板），raftstore 没处理过来，通常情况下短时间的 channel full 不会影响服务

- 4.3.4 TiKV coprocessor 排队，任务堆积超过了 coprocessor 线程数 * readpool.coprocessor.max-tasks-per-worker-[normal|low|high]。大量大查询导致 coprocessor 出现了堆积情况，需要确认是否有由于执行计划变化导致出现大量扫表操作，请参考 3.3

### 4.4 某些 TiKV 大量掉 leader

- 4.4.1 TiKV 重启了导致重新选举

	- TiKV panic 之后又被 systemd 重新拉起正常运行，可以通过查看 TiKV 的日志来确认是否有 panic，这种情况属于非预期，需要报 bug
	- 被第三者 stop/kill，被 systemd 重新拉起。查看 dmesg 和 TiKV log 确认原因
	- TiKV 发生 OOM 导致重启了，参考 4.2
	- 动态调整 THP 导致 hung 住，见 ONCALL-500

- 4.4.2 TiKV grafana errors 面板 server is busy 看到 TiKV RocksDB 出现 write stall 导致发生重新选举，请参考 4.3.1
- 网络隔离导致重新选举

### 4.5 TiKV 写入慢

- 4.5.1 通过查看 TiKV gRPC 的 prewrite/commit/raw-put(仅限 raw kv 集群) duration 确认确实是 TiKV 写入慢了。通常情况下可以按照 performance-map 来定位到底哪个阶段慢了，下面列出集中常见的情况
- 4.5.2 scheduler CPU 繁忙（仅限 transaction kv）。prewrite/commit 的 scheduler command duration 比 scheduler latch wait duration + storage async write duartion 更长，并且 scheduler worker CPU 比较高，例如超过 scheduler-worker-pool-size * 100% 的 80%，并且或者整个机器的 CPU 资源比较紧张。如果写入量很大，确认下是否 [storage] scheduler-worker-pool-size 配置得太小。其他情况请报 bug
- 4.5.3 append log 慢。TiKV grafana 的 Raft IO/append log duration 比较高，通常情况下是由于写盘慢了，可以检查 RocksDB - raft 的 WAL Sync Duration max 值来确认，否则可能需要报 bug
- 4.5.4 raftstore 线程繁忙。TiKV grafana 的 Raft Propose/propose wait duration 明显高于 append log duration。请查看 1）[raftstore] store-pool-size 配置是否过小（该值建议在[1,5] 之间，不建议太大）。2）机器的 CPU 是不是不够了
- 4.5.5 apply 慢了。TiKV grafana 的 Raft IO/apply log duration 比较高，通常会伴随着 Raft Propose/apply wait duration 比较高。可能是 1） [raftstore] apply-pool-size 配置过小（建议在 [1, 5] 之间，不建议太大），Thread CPU/apply cpu 比较高；2）机器的 CPU 资源不够了；3）region 写入热点问题，单个 apply 线程 CPU 使用率比较高（通过修改 grafana 表达式，加上 by (instance, name) 来看各个线程的 cpu 使用情况），暂时对于单个 region 的热点写入没有很好的方式，最近在优化该场景；4）写 RocksDB 比较慢，RocksDB kv/max write duration 比较高（单个 raft log 可能包含很多个 kv，写 rocksdb 的时候会把 128 个 kv 放在一个 write batch 写入到 rocksdb，所以一次 apply log 可能涉及到多次 RocksDB 的 write）；5）其他情况，需要报 bug
- 4.5.6 raft commit log 慢了。TiKV grafana 的 Raft IO/commit log duration 比较高（4.x 版本的 grafana 才有该 metric）。每个 region 对应一个独立的 raft group，raft 本身是有流控机制的，类似 TCP 的滑动窗口机制，通过参数 [raftstore] raft-max-inflight-msgs = 256 来控制滑动窗口的大小，如果有热点写入并且 commit log duration 比较高可以适度调大改参数，比如 1024
- 4.5.7 其他情况，请参考 performance-map 上的写入路径来分析

## 5. PD 问题

### 5.1 PD 调度问题

- 5.1.1 merge 问题

	- 跨表空 region 无法 merge，需要修改 TiKV 的 [coprocessor] split-region-on-table = false 参数来解决，4.x 版本该参数默认为 false。见 ONCALL-896
	- region merge 慢，可检查 PD 监控 operator 面板是否有 merge 的 operator 产生，参考 [PD 调度参数指南（3.0）文档](https://docs.google.com/document/d/1GLyP9RR4hV7Tpy_xacMbcG0tMi4azh75pXocWKy06xo/edit#)
]

- 5.1.2 补副本/上下线问题

	- TIKV 磁盘使用 80% 容量，PD 不会进行补副本操作，miss peer 数量上升，见 ONCALL-801
	- 下线 TiKV，有 region 长时间迁移不走，可能有问题，见 ONCALL-870

- 5.1.3 balance 问题

	- leader/region count 分布不均，见 ONCALL-394, ONCALL-759。主要原因是 balance 是依赖 region/leader 的 size 去调度的，所以可能会造成 count 数量的不均衡，4.0 新增了一个参数 [leader-schedule-policy]，可以调整 leader 的调度策略，根据 "count" 或者是 "size" 进行调度

### 5.2 PD 选举问题

- 5.2.1 PD 发生 leader 切换

	- 磁盘问题，PD 所在的节点 I/O 被打满，排查是否有其他 I/O 高的组件与 PD 混部以及盘的健康情况，可通过 disk performance 监控中 latency 和 load 等指标进行验证，必要时可以使用 [fio](https://internal.pingcap.net/confluence/pages/viewpage.action?pageId=14453828) 进行验证，见 ONCALL-292
	- 网络问题，PD 日志中有 lost the TCP streaming connection，排查 PD 间网络是否有问题，可通过 PD 监控中 etcd 的 round trip 来验证，见 ONCALL-177
	- 系统 load 高，日志中能看到 server is likely overloaded，见 ONCALL-214

- 5.2.2 PD 选不出 leader 或者选举慢

	- 选不出 leader，PD 日志中有 lease is not expired，3.0.x 版本已 fix 该问题, 2.1.9 版本修复，见 ONCALL-875
	- 选举慢，region 加载时间长，从 PD 日志中 grep load regions, 如果出现秒级，则说明较慢，3.0 版本可开启 region storage，可以缩短加载 region 过程，见 ONCALL-429

- 5.2.3 TiDB 执行 SQL 时报 PD timeout

	- PD 没 leader 或者有切换，参考 5.2.1 和 5.2.2
	- 网络问题。排查网络相关情况，通过 blackbox 监控中 ping latency 确定 TiDB 到 PD leader 的网络是否正常
	- PD panic，报 bug
	- PD OOM 参考 5.3
	- 其他原因，通过 curl http://127.0.0.1:2379/debug/pprof/goroutine?debug=2 抓 goroutine，报 bug

- 5.2.4 其他问题

	- PD 报 FATAL 错误，日志中有 range failed to find revision pair，3.0.8 已经 fix 改问题，见 ONCALL-947
	- 其他原因，需报 bug

### 5.3 PD OOM

- 5.3.1 使用 /api/v1/regions 接口时 region 数量过多可能会导致 PD OOM，3.0.8 版本修复
- 5.3.2 gRPC 消息大小没限制，监控可看到 TCP InSegs 较大，3.0.6 版本修复，见 ONCALL-852

### 5.4 grafana 显示问题

- 5.4.1 PD role 显示 follower，grafana 表达式问题，3.0.8 版本修复，见 ONCALL-1022

## 6. 生态 tools 问题

### 6.1 binlog 问题

- 6.1.1 Drainer 中的 sarama 报 EOF 错误

	- Drainer 使用的 Kafka 客户端版本和 Kafka 版本不匹配，需要修改配置 `kafka-version`, 见 [TOOL-199](https://internal.pingcap.net/jira/browse/TOOL-199)

- 6.1.2 Drainer 写 kafka 失败然后 panic，kafka 报 Message was too large 错误

	- binlog 数据太大，造成写 Kafka 的单条消息太大，需要修改 kafka message.max.bytes 等配置解决，见 [ONCALL-789](https://internal.pingcap.net/jira/browse/ONCALL-789)

### 6.2 DM 问题

### 6.3 lightning 问题

