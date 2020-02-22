## 现象
    
    用户部署了两套 TiDB 集群，使用 tidb-binlog 做主备同步，在做 tidb 集群热备测试中，发现时间戳字段的值不一致。差了8个小时。

## 环境信息收集
### 版本
    v4.0.0-alpha

### 部署情况
- TiDB 部署在 k8s 上面
- 两套 TiDB 集群，通过 tidb-binlog 做同步。
## 分析步骤
- 通过 ` show create table ` 检查两套集群问题表的建表语句,上下游一致。
```sql
CREATE TABLE `test` (
  `id` int(11) DEFAULT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
```
- 通过 ` show global variables like '%zone%' ` 检查两套集群的时区设置。均为：**CST** 。
- 通过 `date -R ` 检查 PUMP 与 Drainer 所在服务器的时区设置。发现使用的是 UTC。
## 结论
- 由于 drainer 在同步过程中需要拼装 sql，然后再同步到下游数据库。 目前 drainer 在处理时间类型的数据的依据是 **/etc/localtime** ，没有支持设置 TZ 环境变量的方式，所以必须确保 drainer 所在的服务器的时区设置，跟上下游数据库时区一致。
