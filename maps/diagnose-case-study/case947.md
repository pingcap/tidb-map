## 现象
* PD leader (PD01) 节点出现重启，日志出现错误：range failed to find revision pair

![](/Users/zhouyueyue/Desktop/resource/case947_1.png)
![](/Users/zhouyueyue/Desktop/resource/case947_2.png)

* TiDB 在 PD leader 挂掉之后三分钟服务不可用

## 问题分析
* 已知信息

>版本 3.0.3 ，PD 在 2019-12-12 02:10:12 左右出现重启，在 40s 后新 leader 正常选举

![](/Users/zhouyueyue/Desktop/resource/case947_3.png)

* 分析步骤

> 根据 PD 重启时间以及 leader 切换正常，共耗时 40s，之后两分钟出现服务不可用，查看 tidb.log

![](/Users/zhouyueyue/Desktop/resource/case947_4.png)

> tidb.log 中出现大量的 PD server timeout 信息

* 问题原因

>从 PD 重启到正常提供服务持续三分钟服务不可用原因：pd 切换 leader 的时候重新加载 region 数据的时候有 bug，可能会误删更新的 region 信息导致出现空洞，tidb 此时询问 pd 该 region 范围的 key 就会返回 region not found，只能等该 region 下次上报（默认 60s 上报一次），同时加载时间跟 region 个数成正比，导致不可用时间加长

## 解决办法
>恢复时误删 region 信息在 3.0.8 会修复，对应 [PR](https://github.com/pingcap/pd/pull/2022)。PD 挂掉问题是 etcd bug，在 3.0.8 修复。同时为了加快 region load，在做一个同步 region 到 cache 的功能，这样不需要从盘重新 load(已经合到 master)
