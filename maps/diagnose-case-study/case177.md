## 现象

-  两地三中心场景中网络异常情况下避免 PD 触发不必要选举案例

- 中午 11:48，网络支撑部门在尚未告知数据库部门情况下，进行了网络变更操作。将 A 区域 -> B 区域的路由规则切换成了 A 区域 -> C 区域-> B 区域的路由规则。切换过程中出现不到 1s 的连接中断，碰巧触发了 B 区域的 PD 发起了选举请求。原 PD leader PD2 失去 leader 角色，在 22s 内发生了几轮选举之后，leader 角色最终回到了 PD2 ，造成集群不可用时间达 22s，导致近千条 SQL 执行失败，影响了近百笔业务。

## 环境信息收集

- 两地三中心拓扑 PD 拓扑环境为区域 A 和 区域 D 同城 IDC，区域 B 为异地 IDC。
- 后面的分析步骤和结论中 异地 B 区域的 PD name 为 PD5,同城 A 区域的 PD name 为 PD2，同城 C 区域的 PD name 为 PD1。

### 版本： TiDB 集群版本为 release-2.0 版本，具体版本不详。

### 分析步骤

- PD 的日志排查发现 PD 发生选举的情况，网络变更导致 PD5 长时间没有收到心跳，发生选举，request vote @term 229 消息到达 PD2 ，使其 step down，后续 pd1 2 5 又连续发生了多轮选举，分别为：

  - pd 2 become candidate @term 230
  - pd 5 become candidate @term 231
  - pd 1 become leader @term 232
  - pd 1 transfer leadership from pd 1 to pd 2
  - pd 2 become leader @term 233

总计时间花费 22 秒，期间有业务正在操作，TiKV 集群无异常。

- PD leader 日志信息如下：
![pd2 leader log](./resources/case177-1.jpg)

### 结论

- 为了防止这种网络抖动导致的重新选举，最干净利索的方式是开启 Prevote，不过该集群使用的 2.0 不支持此特性，2.1 以上版本默认是开启的。

- 为网络不稳定的机房配置更长的 election timeout，也能一定程度上防止重新选举，只要抖动时的延迟不超过 election timeout。设置不同的 election timeout 还可以避免发生重新选举时，低优先级的 PD 当选为 leader，然后随后产生的 transfer leader。配置方法是优化级越低，election timeout 越长。

- 但是设置不同的 election timeout 会带来一些副作用：
  - 如果 election timeout 很长的 PD 成为 leader（PD 宕机或网络隔离导致），再把 leader 转移至其他节点会有更长的不可用时间。比如相比于 3s 的 election timeout，10s 的配置恢复时间要多(10-3)x1.5=10s
  - 如果启用 lease read，会有一致性问题（PD 现在没用）。

- 配置方法:

  - 如果要为不同机房设置不同的 election timeout，设置方法是修改[静态配置文件](https://pingcap.com/docs-cn/stable/reference/configuration/pd-server/configuration-file/) `pd.toml`，在 config 文件最外层加一行。然后 PD 节点通过滚动重启生效。详情可以看一下官方文档，关于 `PD 配置文件描述` 的部分。
  
   ```yaml
    election-interval = "3s"
   ``` 

  - 另外建议的配置是对应 [PD leader priority](https://pingcap.com/docs-cn/stable/reference/tools/pd-control/) 3,2,1，分别配置为 3s、5s、10s，可以通过 `PD control` 动态修改 PD 作为 leader 的优先级。

