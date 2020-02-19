## 现象

- 某集群在凌晨 8:33 左右发生 PD leader 异常 transfer 问题，leader 没有选举成功，造成集群异常，TiDB 无法正常提供服务。

## 环境信息收集

- TiDB、TiKV、PD、Monitoring 拓扑信息
  
|组件|拓扑|备注|
|---|---|---|
|TiDB| 2 实例 * 3 物理机||
|TiKV| 3 实例 * 27 物理机|SSD RAID5|
|PD| 3 实例 * 1 物理机|普通 SATA 盘;原 PD leader 的 PD name 为 PD3，其他两个 PD name 分别为 PD1，PD2|
|Prometheus|1 实例 *  1 物理机|与 PD leader 的物理机共用，且磁盘为 SAS 盘|

### 版本： v2.0.6

### 分析步骤

- 根据用户反馈现象分析原 PD leader log 发现存在 `[warning] clock offset`  问题，而且延迟时间超过 4s，排除系统时间不准确问题后，猜测可能是磁盘延迟问题，触发选举。

```log
[warning] clock offset: 4.63034429s,prev: 2019-04-26 08:33:38.675474225 +0000 CST m=+15776264.977596228, now: 2019-04-26 08:33:43.38598854 +0000 CST m=+15776269.608030601
```

- 接着 PD3 leader 日志中就开始出现 `[error] campaign leader err` ，说明 PD leader 已经开始发生选举。

![PD leader log](./resources/case292-1.png)

- 从 Grafana 监控的 `Disk Performance` 监控 PD leader 的磁盘监控数据，可以发现磁盘 I/O 打满，而且整体负载非常高，经过了解该 PD leader 存储数据文件的文件系统，和 Pump server 的 binlog 以及 Prometheus Server 的监控数据共同使用相同的数据盘，在出现 I/O 负载高的时候，pump server 有大量的 binlog 写入。

![PD leader log](./resources/case292-2.png)

- follower PD 的 log ，发现原 PD leader 因为时间延迟，触发选举后，实际一直没有选举成功，导致没有 leader ，一直输出日志

- PD2 输出日志

```log
[info] pd2 is not etcd leader, skip campaign leader and check later.
```

- PD1 输出日志

```log
[info] pd1 is not etcd leader, skip campaign leader and check later.
```

- PD 经过 30 min 左右时间未选举成功新的 PD leader ，从日志中可以看到一直在等待 PD leader 选举。

```log
2019/04/26 08:34:36.108 leader.go.103: [info] pd2 is not etcd leader, skip campaign leader and check later.
```

### 结论

1. 为什么 PD leader 会掉 ？

- 因为 PD 的盘是 SATA 机械盘，同时 pump、prometheus 和 pd 组件的数据、日志都在这个盘创建的文件系统上面，该集群盘的 I/O 比较高。PD3 这个节点从 PD 的日志上面看，是有报错的。“2019/04/26 08:33:43.345 leader.go:109: [error] campaign leader err /home/jenkins/workspace/build_pd_2.0/go/src/github.com/pingcap/pd/server/tso.go:69: save timestamp failed, maybe we lost leader” ,save timestamp failed ,会触发 pd leader 选举。另外 clock offset 也是因为存 tso 慢了一拍触发的日志，并不是真的系统时间有问题。修复该问题需要优化集群拓扑就够，尽量为 PD 提供高质量且单独资源的磁盘来进行读写操作盘。

2. 为什么选不出 PD leader ？

- PD 掉 leader 之后，客户端（也就是 TiDB）会重新发送 GetMember 来查找最新的 leader，2.0.x 版本在处理 GetMember 的地方会触发 etcd 读取 leader_priority，请求量过多（TiDB 数量多时更明显）后会导致 PD 重新成为 leader 之后加载 region 的过程变慢（region 数量较多时更明显），于是就选不出来 leader 。修复这个问题需要升级到 2.1 或者 3.0 版本已经修复该问题。