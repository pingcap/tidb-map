## 现象
    
    用户表示 drainer 不停重启服务。

## 环境信息收集
### 版本
    v3.0.3
### 部署情况
- TiDB 通过 ansible 进行部署
- TiDB 通过 drainer 同步 binlog 到 kafka

## 分析步骤
- 检查 Pump 的日志发现存在 " drainer's checkpoint is older than pump gc ts . some binlogs are purged ".
- 检查 Drainer 日志发现有 Panic 的报错日志。
>    goroutine 304 [running]:
    github.com/pingcap/tidb-binlog/drainer/sync.(*KafkaSyncer).run.func2(0xc0005cc4f0, 0xc00b50a070)
    /home/jenkins/workspace/release_tidb_3.0/go/src/github.com/pingcap/tidb-binlog/drainer/sync/kafka.go:188 +0xa9
    created by github.com/pingcap/tidb-binlog/drainer/sync.(*KafkaSyncer).run
    /home/jenkins/workspace/release_tidb_3.0/go/src/github.com/pingcap/tidb-binlog/drainer/sync/kafka.go:184 +0xd0
    2019/10/30 20:54:04 Connected to 172.16.12.138:2181
    2019/10/30 20:54:04 Authenticated: id=72120316523327247, timeout=40000
    2019/10/30 20:54:04 Re-submitting `0` credentials after reconnect
    2019/10/30 20:54:04 Recv loop terminated: err=EOF
    2019/10/30 20:54:04 Send loop terminated: err=<nil>
    panic: kafka: Failed to produce message to topic 6745241072873497585_obinlog: kafka server: Message was too large, server rejected it to avoid allocation error.
- 检查 Kafka 日志发现 " Message was too large, server rejected it to avoid allocation error "
- 修改 Kafka 配置如下，问题解决。
```properties
message.max.bytes=1073741824 
replica.fetch.max.bytes=1073741824 
fetch.message.max.bytes=1073741824 
```
## 结论
- 由于事务修改数据较多导致单个消息过大写 kafka 失败，drainer 写失败后主动 panic, 后序被不断重复拉起，会重复写这个失败消息前的数据（这个是预期的)。 panic 的 log 打在 std_err, 后续版本已改 打 log 文件再退出，方便看到问题。 
