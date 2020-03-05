# A map to guide contributors how to contribute.

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
* [Documentations](#documentations)
* [AskTUG(CN)](#asktugcn)
* [PingCAP University(CN)](#pingcap-universitycn)
* [SIG - Special Interest Group](#sig---special-interest-group)

<!-- vim-markdown-toc -->

## [TiDB](https://github.com/pingcap/tidb) is an open-source distributed HTAP database compatible with the MySQL protocol

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Parser |A Yacc generated parser that is highly compatible with MySQL syntax. | [parser](https://github.com/pingcap/parser)|Golang, Yacc | Bison [manual](https://www.gnu.org/software/bison/manual/html_node/index.html), [Compilers](https://www.amazon.com/Compilers-Principles-Techniques-Tools-2nd/dp/0321486811): Principles, Techniques, and Tools|All the issues [here](https://github.com/pingcap/parser/issues) (including the bugfix, new features, code style, etc.) | TiDB source code reading : TiDB SQL [Parser Implementation(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-5/), Become Contributor in 30 minutes - [Improved TiDB Parser compatibility with MySQL 8.0 syntax(CN)](https://pingcap.com/blog-cn/30mins-become-contributor-of-tidb-20190808/), Parser repo [README](https://github.com/pingcap/parser) |
| DDL | This module is used to realize that when different TiDBs in a cluster transition to the new schema, all TiDBs can access and update all data online. | [ddl](https://github.com/pingcap/tidb/tree/master/ddl) | Golang | Online, Asynchronous Schema Change in [F1](https://static.googleusercontent.com/media/research.google.com/zh-CN//pubs/archive/41376.pdf), Deep [analysis](https://github.com/ngaut/builddatabase/blob/master/f1/schema-change.md) of Google F1's schema change algorithm(CN), TiDB source code reading : [DDL(CN)](https://pingcap.com/blog-cn/tidb-source-code-reading-17/), TiDB DDL [architecture](https://github.com/pingcap/tidb/blob/master/docs/design/2018-10-08-online-DDL.md) | [issues](https://github.com/pingcap/tidb/issues/14800) | |
| MySQL Protocol | | [server](https://github.com/pingcap/tidb/tree/master/server) | | | | |
| Transaction | A transaction symbolizes a unit of work performed within TiDB. The transaction module in TiDB plays the role of coordinator of distributed transactions. | [session](https://github.com/pingcap/tidb/tree/master/session), [kv](https://github.com/pingcap/tidb/tree/master/kv), [memdb](https://github.com/pingcap/tidb/tree/master/kv/memdb), store/[tikv](https://github.com/pingcap/tidb/tree/master/store/tikv), store/[mockstore](https://github.com/pingcap/tidb/tree/master/store/mockstore), store/mockstore/[mocktikv](https://github.com/pingcap/tidb/tree/master/store/mockstore/mocktikv)|Golang, ACID, 2PC, Percolator transaction model | A Critique of ANSI SQL [Isolation Levels](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr-95-51.pdf), [The Art of Database Transaction Processing: Transaction Management and Concurrency Control (Database Technology Series)(Chinese Edition)](https://www.amazon.com/%E6%95%B0%E6%8D%AE%E5%BA%93%E4%BA%8B%E5%8A%A1%E5%A4%84%E7%90%86%E7%9A%84%E8%89%BA%E6%9C%AF%EF%BC%9A%E4%BA%8B%E5%8A%A1%E7%AE%A1%E7%90%86%E4%B8%8E%E5%B9%B6%E5%8F%91%E6%8E%A7%E5%88%B6-%E6%95%B0%E6%8D%AE%E5%BA%93%E6%8A%80%E6%9C%AF%E4%B8%9B%E4%B9%A6-Chinese-%E6%9D%8E%E6%B5%B7%E7%BF%94-ebook/dp/B076VHP4T6), Two-phase commit [protocol](https://en.wikipedia.org/wiki/Two-phase_commit_protocol) , [Large-scale Incremental Processing Using Distributed Transactions and Notifications](https://research.google/pubs/pub36726/) | | |
| Planner | | [planner](https://github.com/pingcap/tidb/tree/master/planner) | Golang | | | |
| Executor | | [executor](https://github.com/pingcap/tidb/tree/master/executor), [expression](https://github.com/pingcap/tidb/tree/master/expression), [chunk](https://github.com/pingcap/tidb/tree/master/util/chunk), store/[tikv](https://github.com/pingcap/tidb/tree/master/store/tikv) | Golang,Relational Algebra, Parallel Programming | TiDB source code reading : [Introduction to Chunk and Execution Framework](https://pingcap.com/blog-cn/tidb-source-code-reading-10/), TiDB source code reading : [Hash Join](https://pingcap.com/blog-cn/tidb-source-code-reading-9/), TiDB source code reading : [Index Lookup Join](https://pingcap.com/blog-cn/tidb-source-code-reading-11/), TiDB source code reading : [Hash Aggregation](https://pingcap.com/blog-cn/tidb-source-code-reading-22/), CMU: Advanced DB System - [Query Execution](https://www.youtube.com/watch?v=v1P-aZvPcJQ&list=PLSE8ODhjZXja7K1hjZ01UTVDnGQdx5v5U&index=15) | | |

## [TiKV](https://github.com/tikv/tikv), distributed transactional key-value database

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Util | Utilities like thread-pool, logger, encoding and decoding, etc. | [Utilities](https://github.com/tikv/tikv/tree/master/components/tikv_util),  Pipeline [batch system](https://github.com/tikv/tikv/tree/master/components/batch-system) | Rust | [Rust book](https://doc.rust-lang.org/book/), [Practical networked applications in Rust](https://github.com/pingcap/talent-plan),  [Protocol buffers](https://developers.google.com/protocol-buffers), TiKV source code reading: [service layer(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-9/), [gRPC concepts](https://grpc.io/docs/guides/concepts/) | [Issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22S%3A+HelpWanted%22) want help| [Land your first Rust PR in TiKV](https://pingcap.com/blog/adding-built-in-functions-to-tikv/), [Became TiKV Contributor in 30 minutes(CN)](https://pingcap.com/blog-cn/30mins-become-contributor-of-tikv/) |
| Network | Network layer | [Server](https://github.com/tikv/tikv/tree/master/src/server) | Rust, Protobuf, gRPC | Ditto | Ditto | Ditto |
| Raw KV API |  | API [entrance](https://github.com/tikv/tikv/blob/master/src/server/service/kv.rs), [Storage struct](https://github.com/tikv/tikv/blob/master/src/storage/mod.rs) | Rust | Ditto | Ditto | Ditto |
| Transaction KV API | | API [entrance](https://github.com/tikv/tikv/blob/master/src/server/service/kv.rs), Implementation of [Transaction](https://github.com/tikv/tikv/tree/master/src/storage), [GC worker](https://github.com/tikv/tikv/tree/master/src/server/gc_worker), [Pessimistic transaction](https://github.com/tikv/tikv/tree/master/src/server/lock_manager) | Rust, 2PC, Percolator transaction model | [Two Phase Commit](https://en.wikipedia.org/wiki/Two-phase_commit_protocol), Percolator [paper](https://research.google/pubs/pub36726/), TiKV source code reading : [storage(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-11/), TiKV source code reading : [distributed transaction(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-12/), TiKV source code reading [MVCC read(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-12/) | | |
| Multi-raft | | [Raftstore](https://github.com/tikv/tikv/tree/master/components/raftstore) | Rust, Raft | Rust [book](https://doc.rust-lang.org/book/), [Practical networked applications in Rust](https://github.com/pingcap/talent-plan), Raft [paper](https://raft.github.io/raft.pdf), Raft implementation in [etcd](https://github.com/etcd-io/etcd/tree/master/raft) | | |
| Engine | | [Engine traits](https://github.com/tikv/tikv/tree/master/components/engine_traits), [Engine rocks](https://github.com/tikv/tikv/tree/master/components/engine_rocks) | Rust, RocksDB | | [Engine abstraction](https://github.com/tikv/tikv/issues/6402) | |
| Coprocessor | | [TiDB query](https://github.com/tikv/tikv/tree/master/components/tidb_query), [TiDB query codegen](https://github.com/tikv/tikv/tree/master/components/tidb_query_codegen), [TiDB query datatype](https://github.com/tikv/tikv/tree/master/components/tidb_query_datatype) | Rust | TiKV source code reading : [Coprocessor Overview(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-14/), TiKV source code reading : [Coprocessor Executor](https://pingcap.com/blog-cn/tikv-source-code-reading-16/) | Coprocessor [Issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22C%3A+Copr%22) | |
| Backup | | [Backup source code](https://github.com/tikv/tikv/tree/master/components/backup) | | | | |

## [PD](https://github.com/pingcap/pd) Placement driver for TiKV

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| API | HTTP interfaces for interacting with PD server | [API](https://github.com/pingcap/pd/tree/master/server/api)| Golang | [Golang http lib](https://golang.org/pkg/net/http/), [Golang Mux](https://www.gorillatoolkit.org/pkg/mux) | OpenAPI Specification | |
| TSO | Centralized timestamp allocation | [TSO](https://github.com/pingcap/pd/tree/master/server/tso) | Golang, etcd | [Lamport timestamps](https://en.wikipedia.org/wiki/Lamport_timestamps), [etcd clientv3](https://godoc.org/go.etcd.io/etcd/clientv3) | [Optimize the performance](https://github.com/pingcap/pd/issues/1847) | |
| Core | Basic facilities | [Core](https://github.com/pingcap/pd/tree/master/server/core) | Golang | [PD best practice(CN)](https://pingcap.com/blog-cn/best-practice-pd/)| Improve hotspot recognition; adaptive Scheduling; scheduling according to region histogram | |
| Statistics | Statistics which the scheduling relies on | [Statistics](https://github.com/pingcap/pd/tree/master/server/statistics) | Golang | Ditto | Ditto | |
| Scheduler | Controllers of scheduling | [Schedulers](https://github.com/pingcap/pd/tree/master/server/schedulers) | Golang | Ditto | Ditto | |
| Schedule | Components related to scheduling like selector, filter, etc. | [Schedule](https://github.com/pingcap/pd/tree/master/server/schedule) | Golang | Ditto | Ditto | |

## TiKV Clients

| *Module* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- |
| [Rust Client](https://github.com/tikv/client-rust) | Rust, TiKV concepts, Transaction model | [TiKV documentation](https://tikv.org/docs/3.0/concepts/overview/), [Rust book](https://doc.rust-lang.org/book/), [Practical networked applications in Rust](https://github.com/pingcap/talent-plan), [Percolator paper](https://research.google/pubs/pub36726/) | [Issues](https://github.com/tikv/client-rust/issues) | |
| [Go Client](https://github.com/tikv/client-go) | Golang, TiKV concepts, Transaction model | Ditto | [Issues](https://github.com/tikv/client-go/issues) | |
| [Java Client](https://github.com/tikv/client-java) | Java, TiKV concepts, Transaction model | Ditto | | |
| [C Client](https://github.com/tikv/client-c) | C/C++, TiKV concepts, Transaction model | Ditto| [Issues](https://github.com/tikv/client-c/issues) | |

## Libraries depended by TiKV

| *Module* | *Description* | *Code Directory* | *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| [grpc-rs](https://github.com/tikv/grpc-rs) | The gRPC library for Rust built on C Core library and futures | grpc [c bindings](https://github.com/tikv/grpc-rs/grpc-sys), grpc [rust wrapper](https://github.com/tikv/grpc-rs) | C++, Rust | grpc [introduction](https://grpc.io), Rust [bindgen](https://rust-lang.github.io/rust-bindgen/), Rust [async book](https://rust-lang.github.io/async-book/01_getting_started/01_chapter.html),  Source code reading: [grpc-rs(CN)](https://pingcap.com/blog-cn/tikv-source-code-reading-8/) | Load balance; reflection; custom metadata; migrate to async/await|  |
| [raft-rs](https://github.com/tikv/raft-rs) | Raft distributed consensus algorithm implemented in Rust | | Rust, Raft | Raft [paper](https://raft.github.io/raft.pdf), Raft [implementation in etcd](https://github.com/etcd-io/etcd/tree/master/raft) | | |
| [rust-rocksdb](https://github.com/tikv/rust-rocksdb) | Rust wrapper for RocksDB | | Rust, C++, RocksDB | Rust [ffi](https://doc.rust-lang.org/nomicon/ffi.html), Rust [bindgen](https://rust-lang.github.io/rust-bindgen/), RocksDB [wiki](https://github.com/facebook/rocksdb/wiki) | Migrate bindgen to C++ | |
| [Titan](https://github.com/tikv/titan) | A RocksDB plugin for key-value separation | | C++, LSM-tree, RocksDB| Titan storage [design and implementation](https://pingcap.com/blog/titan-storage-engine-design-and-implementation/), [WiscKey](https://www.usenix.org/system/files/conference/fast16/fast16-papers-lu.pdf) Separating Keys from Values in SSD-conscious Storage, RocksDB [wiki](https://github.com/facebook/rocksdb/wiki)| | |

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

## [AskTUG(CN)](https://asktug.com/)

| *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- |
| Anyone of ansible, linux, DM, Binlog, lightning, pd, tidb, tikv, grafana, prometheus | [TiDB DBA courses](https://university.pingcap.com/tidb-dba-courses/)| Help other TiDB users by answering questions; Publish practice articles of using TiDB or other databases | SOP, FAQ |

## PingCAP [University(CN)](https://university.pingcap.com/)
| *Required Skills* | *Learning Materials* | *What I can Contribute* | *Contributing Tutorials* |
| ---- | ---- | ---- | ---- |
| | | TiDB DBA Course Design; TiDB Contributor Course Design| |

## SIG - Special Interest Group

| *SIG Name* | *Description* | *Join In* |
| ---- | ---- | ---- |
| Engine | Build a fast, reliable storage engine. Works included in repo [RocksDB](https://github.com/facebook/rocksdb), [Titan](https://github.com/tikv/titan), and [rust-rocksdb](https://github.com/tikv/rust-rocksdb), and etc. | https://tikv-wg.slack.com channel: engine-sig |
| Coprocessor | TiKV Coprocessor is the computing component for TiDB's pushdown requests. | https://tikv-wg.slack.com channel: copr-sig |
