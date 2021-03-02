# A map that guides what and how contributors can contribute

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [TiDB is an open-source distributed HTAP database compatible with the MySQL protocol](#tidb-is-an-open-source-distributed-htap-database-compatible-with-the-mysql-protocol)
* [TiKV, distributed transactional key-value database](#tikv-distributed-transactional-key-value-database)
* [PD Placement driver for TiKV](#pd-placement-driver-for-tikv)
* [TiKV Clients](#tikv-clients)
* [Libraries depended by TiKV](#libraries-depended-by-tikv)
* [Ecosystem Tools: DM Data Migration Platform](#ecosystem-tools-dm-data-migration-platform)
* [Ecosystem Tools - Binlog : A tool used to collect and merge tidb's binlog for real-time data backup and synchronization](#ecosystem-tools---binlog--a-tool-used-to-collect-and-merge-tidbs-binlog-for-real-time-data-backup-and-synchronization)
* [Ecosystem Tools - Lightning: A high-speed data import tool for TiDB](#ecosystem-tools---lightning-a-high-speed-data-import-tool-for-tidb)
* [Ecosystem Tools - BR: A command-line tool for distributed backup and restoration of the TiDB cluster data](#ecosystem-tools---br-a-command-line-tool-for-distributed-backup-and-restoration-of-the-tidb-cluster-data)
* [TiDB on K8S/Docker : Creates and manages TiDB clusters running in Kubernetes](#tidb-on-k8sdocker--creates-and-manages-tidb-clusters-running-in-kubernetes)
* [Deployment Tools - tidb-ansible: A tool to capture data change of TiDB cluster](#deployment-tools---tidb-ansible-a-tool-to-capture-data-change-of-tidb-cluster)
* [Chaos-Mesh: A Chaos Engineering Platform for Kubernetes](#chaos-mesh-a-chaos-engineering-platform-for-kubernetes)
* [Documentation](#documentation)
* [TUG(CN)](#tugcn)
* [PingCAP University(CN)](#pingcap-universitycn)
* [SIG - Special Interest Group](#sig---special-interest-group)

<!-- vim-markdown-toc -->

## [TiDB](https://github.com/pingcap/tidb) is an open-source distributed HTAP database compatible with the MySQL protocol

Contribution tutorial: 

- Become Contributor in 30 minutes - [Improved TiDB Parser compatibility with MySQL 8.0 syntax(CN)](https://pingcap.com/blog-cn/30mins-become-contributor-of-tidb-20190808/)

- Parser repo [README](https://github.com/pingcap/parser)

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | Source Reading | *What I can Contribute* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Parser |A Yacc generated parser that is highly compatible with MySQL syntax. | [parser](https://github.com/pingcap/parser)|Golang, Yacc | <li>[Bison manual](https://www.gnu.org/software/bison/manual/html_node/index.html) <li>[Compilers: Principles, Techniques, and Tools](https://www.amazon.com/Compilers-Principles-Techniques-Tools-2nd/dp/0321486811) |[TiDB SQL Parser Implementation(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-5/) |All the issues [here](https://github.com/pingcap/parser/issues) (including the bugfix, new features, code style, etc.) |
| DDL | This module is used to realize that when different TiDBs in a cluster transition to the new schema, all TiDBs can access and update all data online. | [ddl](https://github.com/pingcap/tidb/tree/master/ddl) | Golang | <li>[Online, Asynchronous Schema Change in F1](https://static.googleusercontent.com/media/research.google.com/zh-CN//pubs/archive/41376.pdf)<li>[Deep analysis of Google F1's schema change algorithm(CN)](https://github.com/ngaut/builddatabase/blob/master/f1/schema-change.md)  <li>[TiDB DDL architecture](https://github.com/pingcap/tidb/blob/master/docs/design/2018-10-08-online-DDL.md) | [TiDB DDL Implementation(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-17/) | [issues](https://github.com/pingcap/tidb/issues/14800) |
| MySQL Protocol | | [server](https://github.com/pingcap/tidb/tree/master/server) | | | | |
| Transaction | A transaction symbolizes a unit of work performed within TiDB. The transaction module in TiDB plays the role of coordinator of distributed transactions. | <li>[session](https://github.com/pingcap/tidb/tree/master/session)<li>[kv](https://github.com/pingcap/tidb/tree/master/kv)<li>[memdb](https://github.com/pingcap/tidb/tree/master/kv/memdb)<li>[store/tikv](https://github.com/pingcap/tidb/tree/master/store/tikv)<li>[store/mockstore](https://github.com/pingcap/tidb/tree/master/store/mockstore)<li>[store/mockstore/mocktikv](https://github.com/pingcap/tidb/tree/master/store/mockstore/mocktikv) |Golang, ACID, 2PC, Percolator transaction model | <li>[A Critique of ANSI SQL Isolation Levels](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr-95-51.pdf)<li>[The Art of Database Transaction Processing: Transaction Management and Concurrency Control (Database Technology Series)(Chinese Edition)](https://www.amazon.com/%E6%95%B0%E6%8D%AE%E5%BA%93%E4%BA%8B%E5%8A%A1%E5%A4%84%E7%90%86%E7%9A%84%E8%89%BA%E6%9C%AF%EF%BC%9A%E4%BA%8B%E5%8A%A1%E7%AE%A1%E7%90%86%E4%B8%8E%E5%B9%B6%E5%8F%91%E6%8E%A7%E5%88%B6-%E6%95%B0%E6%8D%AE%E5%BA%93%E6%8A%80%E6%9C%AF%E4%B8%9B%E4%B9%A6-Chinese-%E6%9D%8E%E6%B5%B7%E7%BF%94-ebook/dp/B076VHP4T6)<li>[Two-phase commit protocol](https://en.wikipedia.org/wiki/Two-phase_commit_protocol)<li> [Large-scale Incremental Processing Using Distributed Transactions and Notifications](https://research.google/pubs/pub36726/) | [Two phase committer(CN)](<https://pingcap.com/blog-cn/tidb-source-code-reading-19/#twophasecommitter>) | |
| Planner | | [planner](https://github.com/pingcap/tidb/tree/master/planner) | Golang | | | |
| Executor | | <li>[executor](https://github.com/pingcap/tidb/tree/master/executor)<li>[expression](https://github.com/pingcap/tidb/tree/master/expression)<li>[chunk](https://github.com/pingcap/tidb/tree/master/util/chunk)<li>[store/tikv](https://github.com/pingcap/tidb/tree/master/store/tikv) | Golang, Relational Algebra, Parallel Programming | [CMU: Advanced DB System - Query Execution](https://www.youtube.com/watch?v=v1P-aZvPcJQ&list=PLSE8ODhjZXja7K1hjZ01UTVDnGQdx5v5U&index=15) | <li>[Introduction to Chunk and Execution Framework(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-10/)<li>[TiDB Hash Join(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-9/)<li> [Index Lookup Join(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-11/)<li> [Hash Aggregation(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-22/) | |

## [TiKV](https://github.com/tikv/tikv), distributed transactional key-value database

Contribution tutorial:

- [Land your first Rust PR in TiKV](https://pingcap.com/blog/adding-built-in-functions-to-tikv/)
- [Became TiKV Contributor in 30 minutes(CN)](https://pingcap.com/blog-cn/30mins-become-contributor-of-tikv/)

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | Source Reading | *What I can Contribute* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Util | Utilities like thread-pool, logger, encoding and decoding, etc. | <li>[Utilities](https://github.com/tikv/tikv/tree/master/components/tikv_util)<li>[Pipeline batch system](https://github.com/tikv/tikv/tree/master/components/batch-system) | Rust | <li>[Rust book](https://doc.rust-lang.org/book/)<li>[Practical networked applications in Rust](https://github.com/pingcap/talent-plan)<li>[Protocol buffers](https://developers.google.com/protocol-buffers)<li> [gRPC concepts](https://grpc.io/docs/guides/concepts/) | [Service layer(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-9/) | [Issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Astatus%2Fhelp-wanted) want help|
| Network | Network layer | [Server](https://github.com/tikv/tikv/tree/master/src/server) | Rust, Protobuf, gRPC | Ditto |  | Ditto |
| Raw KV API |  | <li>[API entrance](https://github.com/tikv/tikv/blob/master/src/server/service/kv.rs)<li>[Storage struct](https://github.com/tikv/tikv/blob/master/src/storage/mod.rs) | Rust | Ditto |  | Ditto |
| Transaction KV API | | <li>[API entrance](https://github.com/tikv/tikv/blob/master/src/server/service/kv.rs)<li>[Transaction](https://github.com/tikv/tikv/tree/master/src/storage)<li>[GC worker](https://github.com/tikv/tikv/tree/master/src/server/gc_worker)<li>[Pessimistic transaction](https://github.com/tikv/tikv/tree/master/src/server/lock_manager) | Rust, 2PC, Percolator transaction model | <li>[Two Phase Commit](https://en.wikipedia.org/wiki/Two-phase_commit_protocol)<li>[Percolator paper](https://research.google/pubs/pub36726/) | <li>[Storage Layer(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-11/)<li>[Distributed transaction(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-12/)<li> [MVCC read(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-12/) | |
| Multi-raft | | [Raftstore](https://github.com/tikv/tikv/tree/master/components/raftstore) | Rust, Raft | <li>[Raft paper](https://raft.github.io/raft.pdf)<li>[Raft implementation in etcd](https://github.com/etcd-io/etcd/tree/master/raft) | <li>[Raftstore overview(CN)](<https://pingcap.com/blog-cn/tikv-source-code-reading-17/>) | |
| Engine | | <li>[Engine traits](https://github.com/tikv/tikv/tree/master/components/engine_traits)<li>[Engine rocks](https://github.com/tikv/tikv/tree/master/components/engine_rocks) | Rust, RocksDB | |  | [Engine abstraction](https://github.com/tikv/tikv/issues/6402) |
| Coprocessor | | <li>[TiDB query](https://github.com/tikv/tikv/tree/master/components/tidb_query)<li>[TiDB query codegen](https://github.com/tikv/tikv/tree/master/components/tidb_query_codegen)<li>[TiDB query datatype](https://github.com/tikv/tikv/tree/master/components/tidb_query_datatype) | Rust |  | <li>[Coprocessor Overview(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-14/)<li>[Coprocessor Executor(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-16/) | Coprocessor [Issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3Acomponent%2Fcoprocessor) |
| Backup | | [Backup](https://github.com/tikv/tikv/tree/master/components/backup) | | | | |

## [PD](https://github.com/pingcap/pd) Placement driver for TiKV

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* |
| ---- | ---- | ---- | ---- | ---- | ---- |
| API | HTTP interfaces for interacting with PD server | [API](https://github.com/pingcap/pd/tree/master/server/api)| Golang | <li>[Golang http lib](https://golang.org/pkg/net/http/)<li>[Golang Mux](https://www.gorillatoolkit.org/pkg/mux) | OpenAPI Specification |
| TSO | Centralized timestamp allocation | [TSO](https://github.com/pingcap/pd/tree/master/server/tso) | Golang, etcd | <li>[Lamport timestamps](https://en.wikipedia.org/wiki/Lamport_timestamps)<li>[etcd clientv3](https://godoc.org/go.etcd.io/etcd/clientv3) | [Optimize the performance](https://github.com/pingcap/pd/issues/1847) |
| Core | Basic facilities | [Core](https://github.com/pingcap/pd/tree/master/server/core) | Golang | [PD best practice(CN)](https://pingcap.com/blog-cn/best-practice-pd/)| Improve hotspot recognition; adaptive Scheduling; scheduling according to region histogram |
| Statistics | Statistics which the scheduling relies on | [Statistics](https://github.com/pingcap/pd/tree/master/server/statistics) | Golang | Ditto | Ditto |
| Scheduler | Controllers of scheduling | [Schedulers](https://github.com/pingcap/pd/tree/master/server/schedulers) | Golang | Ditto | Ditto |
| Schedule | Components related to scheduling like selector, filter, etc. | [Schedule](https://github.com/pingcap/pd/tree/master/server/schedule) | Golang | Ditto | Ditto |

## TiKV Clients

| *Module* | *Required Skills* | *Learning Materials* | *What I can Contribute* |
| ---- | ---- | ---- | ---- |
| [Rust Client](https://github.com/tikv/client-rust) | Rust, TiKV concepts, Transaction model | <li>[TiKV documentation](https://tikv.org/docs/3.0/concepts/overview/)<li>[Rust book](https://doc.rust-lang.org/book/)<li>[Practical networked applications in Rust](https://github.com/pingcap/talent-plan)<li>[Percolator paper](https://research.google/pubs/pub36726/) | [Issues](https://github.com/tikv/client-rust/issues) |
| [Go Client](https://github.com/tikv/client-go) | Golang, TiKV concepts, Transaction model | Ditto | [Issues](https://github.com/tikv/client-go/issues) |
| [Java Client](https://github.com/tikv/client-java) | Java, TiKV concepts, Transaction model | Ditto | |
| [C Client](https://github.com/tikv/client-c) | C/C++, TiKV concepts, Transaction model | Ditto| [Issues](https://github.com/tikv/client-c/issues) |

## Libraries depended by TiKV

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | Source Reading | *What I can Contribute* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| [grpc-rs](https://github.com/tikv/grpc-rs) | The gRPC library for Rust built on C Core library and futures | grpc [c bindings](https://github.com/tikv/grpc-rs/grpc-sys), grpc [rust wrapper](https://github.com/tikv/grpc-rs) | C++, Rust | <li>[grpc introduction](https://grpc.io)<li>[Rust bindgen](https://rust-lang.github.io/rust-bindgen/)<li>[Rust async book](https://rust-lang.github.io/async-book/01_getting_started/01_chapter.html) | <li>[gRPC server Initialization(CN)](<https://pingcap.com/blog-cn/tikv-source-code-reading-7/>)<li>[grpc-rs Implementation(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-8/) | Load balance; reflection; custom metadata; migrate to async/await|
| [fail-rs](<https://github.com/tikv/fail-rs>) | A fail point implementation for Rust. |  | Rust | [FreeBSD's failpoints](https://freebsd.org/cgi/man.cgi?query=fail) | [Introduction for fail-rs(CN)](<https://pingcap.com/blog-cn/tikv-source-code-reading-5/>) | |
| [raft-rs](https://github.com/tikv/raft-rs) | Raft distributed consensus algorithm implemented in Rust | | Rust, Raft | <li>[Raft paper](https://raft.github.io/raft.pdf)<li>[Raft implementation in etcd](https://github.com/etcd-io/etcd/tree/master/raft) |  | |
| [rust-prometheus](<https://github.com/tikv/rust-prometheus>) | Prometheus instrumentation library for Rust applications | | Rust | <li>[Prometheus doc](<https://prometheus.io/docs/introduction/overview/>)<li>[Prometheus Go client](<https://github.com/prometheus/client_golang>) | <li>[rust-prometheus basic](<https://pingcap.com/blog-cn/tikv-source-code-reading-3/>)<li>[rust-prometheus advance](<https://pingcap.com/blog-cn/tikv-source-code-reading-4/>) | |
| [rust-rocksdb](https://github.com/tikv/rust-rocksdb) | Rust wrapper for RocksDB | | Rust, C++, RocksDB | <li>[Rust ffi](https://doc.rust-lang.org/nomicon/ffi.html)<li>[Rust bindgen](https://rust-lang.github.io/rust-bindgen/)<li>[RocksDB wiki](https://github.com/facebook/rocksdb/wiki) |  | Migrate bindgen to C++ |
| [Titan](https://github.com/tikv/titan) | A RocksDB plugin for key-value separation | | C++, LSM-tree, RocksDB| <li>[Titan storage design and implementation](https://pingcap.com/blog/titan-storage-engine-design-and-implementation/)<li>[WiscKey: Separating Keys from Values in SSD-conscious Storage](https://www.usenix.org/system/files/conference/fast16/fast16-papers-lu.pdf) | | |

## Ecosystem Tools: [DM](https://github.com/pingcap/dm) Data Migration Platform

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| DM-master | The component for managing and scheduling the operation of data replication task | [dm-master](https://github.com/pingcap/dm/tree/master/dm/master) | Golang, etcd, gRPC, Protobuf | [DM overview](https://pingcap.com/docs/stable/reference/tools/data-migration/overview/), source code reading: [DM(CN)](https://pingcap.com/blog-cn/#DM-%E6%BA%90%E7%A0%81%E9%98%85%E8%AF%BB) | [Issues](https://github.com/pingcap/dm/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) | |
| DM-worker | The component for executing specific data replication tasks | [dm-worker](https://github.com/pingcap/dm/tree/master/dm/worker) | Golang, etcd, gRPC, Protobuf | Ditto | Ditto | |
| dmctl | A command line tool used to control the DM cluster | [dm-ctl](https://github.com/pingcap/dm/tree/master/dm/ctl) | Golang, gRPC, Protobuf | Ditto | Ditto | |
| Dump unit | The processing unit for exporting SQL data from MySQL | [mydumper](https://github.com/pingcap/dm/tree/master/mydumper) | Golang, MySQL | Ditto | Ditto | |
| Import/Load unit | The processing unit for importing SQL data into TiDB | [loader](https://github.com/pingcap/dm/tree/master/loader) | Golang, MySQL | Ditto | Ditto | |
| Relay unit | The processing unit for dumping binlog data from MySQL | [relay](https://github.com/pingcap/dm/tree/master/relay) | Golang, MySQL | Ditto | Ditto | |
| Binlog replication/sync unit | The processing unit for replicating binlog data into TiDB | [syncer](https://github.com/pingcap/dm/tree/master/syncer) | Golang, MySQL | Ditto | Ditto | |
| Checker unit | The processing unit for checking restrictions of the replication | [checker](https://github.com/pingcap/dm/tree/master/checker) | Golang, MySQL | Ditto | Ditto | |
| DM-portal | A web-based application for managing data migration task configuration | [portal](https://github.com/pingcap/dm/tree/master/dm/portal) | Golang, MySQL, Frontend | Ditto | Ditto | |
| DM-ansible | The ansible playbook for DM | [dm-ansible](https://github.com/pingcap/dm/tree/master/dm/dm-ansible) | DM, Ansible | Ditto | Ditto | |
| DM-tracer | A DM-specific tracer framework | [dm-tracer](https://github.com/pingcap/dm/tree/master/dm/tracer)| Golang, gRPC, Protobuf | Ditto | Ditto | |

## Ecosystem Tools - [Binlog](https://github.com/pingcap/tidb-binlog) : A tool used to collect and merge tidb's binlog for real-time data backup and synchronization

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Pump Client | Send Binlog to the appropriate Pump on TiDB | [pump_client](https://github.com/pingcap/tidb-tools/tree/master/tidb-binlog/pump_client), [binloginfo](https://github.com/pingcap/tidb/tree/master/sessionctx/binloginfo)| Golang, gRPC, etcd | TiDB [Binlog overview](https://pingcap.com/docs/stable/reference/tidb-binlog/overview/), TiDB source code reading: [Binlog(CN)](https://pingcap.com/blog-cn/#TiDB-Binlog-%E6%BA%90%E7%A0%81%E9%98%85%E8%AF%BB) | Help Wanted [Issues](https://github.com/pingcap/tidb-binlog/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) | |
| Pump | Receive and store Binlogs, sorted by commitTS | [pump](https://github.com/pingcap/tidb-binlog/tree/master/pump) | Golang, LevelDB, etcd, gRPC | Ditto | Ditto | |
| Drainer | Pull Binlog from Pump, do merge and sort, and then sync to downstream | [drainer](https://github.com/pingcap/tidb-binlog/tree/master/drainer) | Golang, Mysql, Kafka, gRPC | Ditto | Ditto | |

## Ecosystem Tools - [Lightning](https://github.com/pingcap/tidb-lightning): A high-speed data import tool for TiDB

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Web Interface | | [web](https://github.com/pingcap/tidb-lightning/tree/master/web) | | | | |
| CSV and SQL Parser | | [mydump](https://github.com/pingcap/tidb-lightning/tree/master/lightning/mydump) | | | | |
| Delivery backend (output as SQL or as KV pairs) | | [backend](https://github.com/pingcap/tidb-lightning/tree/master/lightning/backend) | | | | |
| Checkpoints | | [checkpoints](https://github.com/pingcap/tidb-lightning/tree/master/lightning/checkpoints) | | | | |
| Configuration | | [config](https://github.com/pingcap/tidb-lightning/tree/master/lightning/config) | | | | |
| Logging | | [log](https://github.com/pingcap/tidb-lightning/tree/master/lightning/log) | | | | |
| Metrics | | [metric](https://github.com/pingcap/tidb-lightning/tree/master/lightning/metric) | | | | |
| Workers (concurrency control) | | [worker](https://github.com/pingcap/tidb-lightning/tree/master/lightning/worker) | | | | |
| Restore Driver | | [restore](https://github.com/pingcap/tidb-lightning/tree/master/lightning/restore) | | | | |
| Utilities | | [common](https://github.com/pingcap/tidb-lightning/tree/master/lightning/common) | | | | |
| Importer | | [import](https://github.com/tikv/importer/tree/master/src/import) | | | | |

## Ecosystem Tools - [BR](https://github.com/pingcap/br): A command-line tool for distributed backup and restoration of the TiDB cluster data

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Backup | Backup data in cluster which has 3 mode: backup full cluster, backup specified DB and backup specified Table| [br/backup](https://github.com/pingcap/br/tree/master/pkg/backup), [tikv/backup](https://github.com/tikv/tikv/tree/master/components/backup) | gRPC, golang, rust | [backup-principle](https://pingcap.com/docs/dev/how-to/maintain/backup-and-restore/br/#backup-principle) | | |
| Restore | Restore data to new cluster after backup, relatively can restore full cluster, restore specified DB and restore specified Table. | [br/restore](https://github.com/pingcap/br/tree/master/pkg/restore), [tikv/sst_importer](https://github.com/tikv/tikv/tree/master/components/sst_importer) | gRPC, golang, rust | [restoration-principle](https://pingcap.com/docs/dev/how-to/maintain/backup-and-restore/br/#restoration-principle) | | |

## TiDB on K8S/Docker : Creates and manages TiDB clusters running in Kubernetes

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| TiDB Operator | TiDB Operator manages TiDB clusters on Kubernetes and automates tasks related to operating a TiDB cluster. It makes TiDB a truly cloud-native database. | [tidb-operator](https://github.com/pingcap/tidb-operator) | Golang, Kubernetes, TiDB | [how to use tidb-operator](https://pingcap.com/docs/stable/tidb-in-kubernetes/tidb-operator-overview/), Kubernetes [Concepts](https://kubernetes.io/docs/concepts/), Kubernetes [client-go SDK](https://godoc.org/k8s.io/client-go/), Kubernetes [Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/), TiDB [Architecture](https://pingcap.com/docs/stable/architecture/), [Helm](https://helm.sh/), [Terraform](https://www.terraform.io/) | Help Wanted [Issues](https://github.com/pingcap/tidb-operator/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22help+wanted%22) | [Contributing Guide](https://github.com/pingcap/tidb-operator/blob/master/docs/CONTRIBUTING.md) |
| Advanced StatefulSet | This is an Advanced StatefulSet CRD implementation based on official StatefulSet in Kubernetes. In addition to the official StatefulSet, it can scale the set in an arbitrary way. | [advanced-statefulset](https://github.com/pingcap/advanced-statefulset) | Golang, Kubernetes | Kubernetes [Concepts](https://kubernetes.io/docs/concepts/), Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/), Kubernetes StatefulSet [Implementations](https://github.com/kubernetes/kubernetes/tree/master/pkg/controller/statefulset), PingCAP StatefulSet [Implementations](https://github.com/pingcap/advanced-statefulset/tree/master/pkg/controller/statefulset) | | |
| TiDB Docker Compose | Docker compose files for TiDB. With it, you can quickly deploy a TiDB testing cluster with a single command. | [tidb-docker-compose](https://github.com/pingcap/tidb-docker-compose)| Docker, Docker Compose | how to [start tidb with tidb-docker-compose](https://pingcap.com/docs/stable/how-to/deploy/orchestrated/docker/), docker [get started](https://docs.docker.com/get-started/),  docker [compose](https://docs.docker.com/compose/)| | |

## Deployment Tools - [tidb-ansible](https://github.com/pingcap/tidb-ansible): A tool to capture data change of TiDB cluster

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| tidb ansible | TiDB deployment operation and maintenance tools | | Ansible, Python, Jinja2, Shell | How to [deploy TiDB cluster through tidb-ansible](https://pingcap.com/docs-cn/stable/how-to/deploy/orchestrated/ansible/), Ansible [docs(en)](https://docs.ansible.com) and [docs(cn)](http://www.ansible.com.cn) | | |

## [Chaos-Mesh](https://github.com/pingcap/chaos-mesh): A Chaos Engineering Platform for Kubernetes

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| chaos-mesh | | | go, kubenetes | | | |

## Documentation

| *Project* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- |
| [Documentation(EN)](https://github.com/pingcap/docs) | Sharp eyes, Good English writing, Technical writing or communication, Translation from English to Chinese, Knowledge about TiDB | [Commit Message and Pull Request Style](https://github.com/pingcap/community/blob/master/contributors/commit-message-pr-style.md), [Code Comment Style](https://github.com/pingcap/community/blob/master/contributors/code-comment-style.md)| Fix typos or format (punctuation, space, indentation, code block, etc.); Fix or update inappropriate or outdated descriptions; Add missing content (sentence, paragraph, or a new document); Translate docs changes from English to Chinese; Submit, reply to, and resolve issues; (Advanced) Review Pull Requests| [docs readme](https://github.com/pingcap/docs/blob/master/README.md), [docs contribution guide](https://github.com/pingcap/docs/blob/master/CONTRIBUTING.md) |
| [Documentation(CN)](https://github.com/pingcap/docs-cn) | Sharp eyes, Good English writing, Technical writing or communication, Translation from English to Chinese, Knowledge about TiDB | [Chinese documentation style guide and template](https://github.com/pingcap/docs-cn/tree/master/resources), [Commit Message and Pull Request Style](https://github.com/pingcap/community/blob/master/contributors/commit-message-pr-style.md), [Code Comment Style](https://github.com/pingcap/community/blob/master/contributors/code-comment-style.md) | Ibid, except for translating document changes from Chinese to English | [docs-cn readme](https://github.com/pingcap/docs-cn/blob/master/README.md), [docs-cn contribution guide](https://github.com/pingcap/docs-cn/blob/master/CONTRIBUTING.md) |

## TUG(CN)

| *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- |
| Anyone of ansible, linux, DM, Binlog, lightning, pd, tidb, tikv, grafana, prometheus. Any experience in using RDBMS like MySQL or other RDBMS. | [TiDB DBA courses](https://university.pingcap.com/tidb-dba-courses/) | Help other TiDB users by answering questions in [AskTUG](https://asktug.com/); Publish practice articles of using TiDB or other databases; Giving presentations at TUG activities to share experience with TiDB; Involving in the organization/management of TUG (TiDB User Group) to expand the user base of TiDB | [Join TUG](http://pingcaptidb.mikecrm.com/gHY23LJ) |

## [PingCAP University(CN)](https://university.pingcap.com/)

| *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- |
| | | TiDB DBA Course Design; TiDB Contributor Course Design; Sharing notes on TiDB; Become an administrator of the Wechat (online) group of learning; Joining the group to make subtitles for the video courses or translate them; Helping answer questions on TiDB; Notes, subtitles, translation, FAQ | [Join PU](http://pingcaptidb.mikecrm.com/zNM8EHE) |

## SIG - Special Interest Group

  Join [tikv-wg](https://join.slack.com/t/tikv-wg/shared_invite/enQtNTUyODE4ODU2MzI0LWVlMWMzMDkyNWE5ZjY1ODAzWYZWYZWYWJGWZGWYG)
  Join [tidb-community](https://join.slack.com/t/tidbcommunity/shared_invite/enQtNzc0MzI4ODExMDc4LWYwYmIzMjZkYzJiNDUxMmZlN2FiMGJkZjAyMzQ5NGU0NGY0NzI3NTYwMjAyNGQ1N2I2ZjAxNzc1OGUwYWM0NzE)

| *SIG Name* | *Description* | *Join In* |
| ---- | ---- | ---- |
| DDL(TiDB) | Covers the TiDB DDL and parser parts. Work includes supporting new features or improving the syntax compatibility between TiDB and MySQL, fixing all kinds of DDL-related and parser-related bugs, and etc. [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-ddl) | channel: [sig-ddl](https://slack.tidb.io/invite?team=tidb-community&channel=sig-ddl&ref=github-sig) |
| Exec(TiDB) | Focuses on the development and maintenance of the TiDB [Function and Operator](https://pingcap.com/docs/dev/reference/sql/functions-and-operators/reference/). [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-exec) | channel: [sig-exec](https://slack.tidb.io/invite?team=tidb-community&channel=sig-exec&ref=tidb-map) |
| Planner(TiDB) | Focuses on the development and maintenance of the TiDB [planner](https://pingcap.com/docs/stable/reference/performance/sql-optimizer-overview/) and [statistics](https://pingcap.com/docs/stable/reference/performance/statistics/) components， make TiDB planner more smart and more accurate. [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-planner) | channel: [sig-planner](https://slack.tidb.io/invite?team=tidb-community&channel=sig-planner&ref=tidb-map) |
| Scheduling(TiDB) | Focuses on the distributed scheduling system in TiDB. Work includes improving the existing scheduling system and developing a new scheduling system. [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-scheduling) | channel: [sig-scheduling](https://slack.tidb.io/invite?team=tidb-community&channel=sig-scheduling&ref=tidb-map) |
| K8S(TiDB) | Supports TiDB Products on Kubernetes and Docker. [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-k8s) | channel: [k8s](https://slack.tidb.io/invite?team=tidb-community&channel=sig-k8s&ref=github-sig) |
| Tools(TiDB) | Improves TiDB surrounding tools, like tidb-lightning, tidb-binlog and so on. [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-tools) | channel: [sig-tools](https://slack.tidb.io/invite?team=tidb-community&channel=sig-tools&ref=tidb-map) |
| Dashboard(TiDB) | Focuses on the development of the [TiDB Dashboard](https://github.com/pingcap-incubator/tidb-dashboard). [Readme](https://github.com/pingcap/community/tree/master/special-interest-groups/sig-dashboard) | channel: [sig-dashboard](https://slack.tidb.io/invite?team=tidb-community&channel=sig-dashboard&ref=tidb-map)|
| Engine(TiKV) | Build a fast, reliable storage engine. Works included in repo [RocksDB](https://github.com/facebook/rocksdb), [Titan](https://github.com/tikv/titan), and [rust-rocksdb](https://github.com/tikv/rust-rocksdb), and etc. [Readme](https://github.com/tikv/community/blob/master/sig/engine/README.md) | channel: [sig-engine](https://slack.tidb.io/invite?team=tikv-wg&channel=sig-engine&ref=github-sig) |
| Coprocessor(TiKV) | TiKV Coprocessor is the computing component for TiDB's pushdown requests. [Readme](https://github.com/tikv/community/blob/master/sig/coprocessor/README.md) | channel: [sig-copr](https://slack.tidb.io/invite?team=tikv-wg&channel=sig-copr&ref=github-sig)|
| Raft(TiKV) | Covers Raft related work in TiKV, including optimize raft-rs and the Multi-Raft implementation in TiKV. [Readme](https://github.com/tikv/community/blob/master/sig/raft/README.md) | channel: [sig-raft](https://slack.tidb.io/invite?team=tikv-wg&channel=sig-raft&ref=github-sig) |
| Transaction(TiKV, TiDB) | Covers transaction related work in TiKV and TiDB, including improve transaction in TiKV and TiDB, and explore new transaction model. [Readme](https://github.com/tikv/community/blob/master/sig/transaction/README.md) | channel: [sig-transaction](https://slack.tidb.io/invite?team=tikv-wg&channel=sig-transaction&ref=github-sig) |
