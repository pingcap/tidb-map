## 现象
    
    在配置了 mem-quota-query 以及 oom-action: cancel 之后，在执行 update 的时候还是会出发系统的 oom killer 被 kill 掉。

## 环境信息收集
### 版本
 v3.0.3 
### 部署情况
 - tidb ansible 部署
 - 50+ tidb 节点，最近从 2.1.x 升级到 3.0.3
## 分析步骤
- 检查 TiDB [mem-quota-query](https://pingcap.com/docs-cn/stable/reference/configuration/tidb-server/configuration-file/#mem-quota-query) 以及 [oom-action](https://pingcap.com/docs-cn/stable/reference/configuration/tidb-server/configuration-file/#oom-action) 配置正确。
- 检查监控以及系统日志发现触发 OOM killer 的时候内存的确超过 **mem-quota-query** 的设置值。
- 检查引起 OOM 的 SQL 执行计划如下：
```sql
//explain update test set username=lower(username) ;
+-------------------+--------------+------+----------------------------------------------------+
| id                | count        | task | operator info                                      |
+-------------------+--------------+------+----------------------------------------------------+
| TableReader_4     | 154191064.00 | root | data:TableScan_3                                   |
| └─TableScan_3 | 154191064.00 | cop  | table:test, range:[-inf,+inf], keep order:false |
+-------------------+--------------+------+----------------------------------------------------+
2 rows in set (0.00 sec)

```

## 结论
- 由于 tidb 目前的 memmory tracker 只追踪了读路径的内存消耗。
- update 语句数据读上来时候未触发到 mem-quota 的阈值，而加上 membuffer 后，触发了操作了系统的 OOM killer，进而造成了 tidb 的 OOM。
- 建议可以通过分 Batch 或者是加 Limit 的方式限制，避免 OOM。
