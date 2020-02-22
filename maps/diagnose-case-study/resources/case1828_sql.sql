 ================ SQL语句=====================
 SELECT tmp_amt.channel_id channel_id, tmp_amt.sub_channel sub_channel, tmp_amt.activity_info activity_info,tmp_amt.product_code product_code,
  0 uv_num, 0 register_num, 0 complete_num_newu, 0 complete_num_oldu, 0 aps_num_newu, 0 aps_amt_newu, 0 aps_num_newu, 0 aps_amt_newu, 0 draw_num_newu, 0 draw_num_oldu,
  0 loan_num_newu, 0 loan_num_oldu, 0 loan_amt_newu, 0 loan_amt_oldu, 0 loan_num_sj, 0 loan_amt_sj, 0 loan_num_fj, 0 loan_amt_fj,
  SUM(tmp_amt.accu_loan_amt) accu_loan_amt, SUM(tmp_amt.acct_repay_amt) acct_repay_amt,
  0 loan_user_sj,0 loan_amt_sj_xxx,0 loan_user_newu,0 loan_user_oldu,0 first_complete_num_newu, 0 first_complete_num_oldu FROM
  (
    select uu.channel_id channel_id, coalesce(uu.sub_channel, '') sub_channel, coalesce(uu.activity_info, '') activity_info,
    case when aae.appl_no is not null and aa.product_code in ('JT', 'JX', 'MA') then aa.product_code||'_BJ' else aa.product_code end as product_code,
    0 accu_loan_amt, sum(COALESCE(flow.trans_prin, 0)) AS acct_repay_amt
    from u_user uu
    join (select aa.user_no, aa.appl_no, aa.contract_no, aa.product_code from ap_appl aa where aa.appl_state='APS' and aa.contract_no is not null  
        AND aa.product_code in ('JT', 'YJ', 'JX', 'MA') group by aa.user_no, aa.appl_no, aa.contract_no, aa.product_code) aa on uu.user_no = aa.user_no    
    join tran_proc_rp flow on aa.contract_no = flow.contract_no
    join ln_loan loan on flow.loan_no = loan.loan_no
    left join ap_appl_ext aae on aa.appl_no = aae.appl_no and aae.credit_ident='Y'
    where flow.date_rp < '2018-10-11 00:00:00' AND flow.status = '03'
    GROUP BY uu.channel_id, coalesce(uu.sub_channel, ''), coalesce(uu.activity_info, ''),
    case when aae.appl_no is not null and aa.product_code in ('JT', 'JX', 'MA') then aa.product_code||'_BJ' else aa.product_code end
    UNION ALL
    select uu.channel_id channel_id, coalesce(uu.sub_channel, '') sub_channel, coalesce(uu.activity_info, '') activity_info,
    case when aae.appl_no is not null and aa.product_code in ('JT', 'JX', 'MA') then aa.product_code||'_BJ' else aa.product_code end as product_code,
    sum(COALESCE(loan.loan_amt, 0)) AS accu_loan_amt,0 acct_repay_amt
    from u_user uu
    join (select aa.user_no, aa.appl_no, aa.contract_no, aa.product_code from ap_appl aa where aa.appl_state='APS' and aa.contract_no is not null  
        AND aa.product_code in ('JT', 'YJ', 'JX', 'MA') group by aa.user_no, aa.appl_no, aa.contract_no, aa.product_code) aa on uu.user_no = aa.user_no     
    join ln_loan loan on aa.contract_no = loan.contract_no
    left join ap_appl_ext aae on aa.appl_no = aae.appl_no and aae.credit_ident='Y'
    where loan.date_created < '2018-10-11 00:00:00'
    GROUP BY uu.channel_id, coalesce(uu.sub_channel, ''), coalesce(uu.activity_info, ''),
    case when aae.appl_no is not null and aa.product_code in ('JT', 'JX', 'MA') then aa.product_code||'_BJ' else aa.product_code end
  ) tmp_amt
  GROUP BY tmp_amt.channel_id, tmp_amt.sub_channel, tmp_amt.activity_info, tmp_amt.product_code 
 
===================执行计划====================
id	count	task	operator info
Projection_37	1000.00	root	tmp_amt.channel_id, tmp_amt.sub_channel, tmp_amt.activity_info, tmp_amt.product_code, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32_col_0, 32_col_1, 0, 0, 0, 0, 0, 0
└─Limit_40	1000.00	root	offset:0, count:1000
└─HashAgg_43	1000.00	root	group by:tmp_amt.activity_info, tmp_amt.channel_id, tmp_amt.product_code, tmp_amt.sub_channel, funcs:sum(tmp_amt.accu_loan_amt), sum(tmp_amt.acct_repay_amt), firstrow(tmp_amt.channel_id), firstrow(tmp_amt.sub_channel), firstrow(tmp_amt.activity_info), firstrow(tmp_amt.product_code)
└─Union_44	17483020.88	root	
├─Projection_45	8741510.44	root	uu.channel_id, cast(sub_channel), cast(activity_info), product_code, cast(accu_loan_amt), acct_repay_amt
│ └─Projection_46	8741510.44	root	uu.channel_id, coalesce(uu.sub_channel, ""), coalesce(uu.activity_info, ""), case(and(not(isnull(aae.appl_no)), in(aa.product_code, "JT", "JX", "MA")), cast(or(cast(aa.product_code), 0)), aa.product_code), 0, 27_col_0
│ └─HashAgg_49	8741510.44	root	group by:case(and(not(isnull(aae.appl_no)), in(aa.product_code, "JT", "JX", "MA")), cast(or(cast(aa.product_code), 0)), aa.product_code), coalesce(uu.activity_info, ""), coalesce(uu.sub_channel, ""), uu.channel_id, funcs:sum(coalesce(flow.trans_prin, 0)), firstrow(uu.channel_id), firstrow(uu.sub_channel), firstrow(uu.activity_info), firstrow(aa.product_code), firstrow(aae.appl_no)
│ └─HashLeftJoin_55	36779454.69	root	left outer join, inner:TableReader_89, equal:[eq(aa.appl_no, aae.appl_no)]
│ ├─HashLeftJoin_60	36779454.69	root	inner join, inner:TableReader_86, equal:[eq(flow.loan_no, loan.loan_no)]
│ │ ├─HashRightJoin_63	96672169.24	root	inner join, inner:IndexJoin_67, equal:[eq(aa.contract_no, flow.contract_no)]
│ │ │ ├─IndexJoin_67	10926888.05	root	inner join, inner:IndexLookUp_66, outer key:aa.user_no, inner key:uu.user_no
│ │ │ │ ├─IndexLookUp_66	1.00	root	
│ │ │ │ │ ├─IndexScan_64	1.00	cop	table:uu, index:user_no, range: decided by [aa.user_no], keep order:false
│ │ │ │ │ └─TableScan_65	1.00	cop	table:cis_u_user, keep order:false
│ │ │ │ └─HashAgg_75	8741510.44	root	group by:col_4, col_5, col_6, col_7, funcs:firstrow(col_0), firstrow(col_1), firstrow(col_2), firstrow(col_3)
│ │ │ │ └─TableReader_76	8741510.44	root	data:HashAgg_70
│ │ │ │ └─HashAgg_70	8741510.44	cop	group by:aa.appl_no, aa.contract_no, aa.product_code, aa.user_no, funcs:firstrow(aa.appl_no), firstrow(aa.user_no), firstrow(aa.contract_no), firstrow(aa.product_code)
│ │ │ │ └─Selection_74	10926888.05	cop	eq(aa.appl_state, "APS"), in(aa.product_code, "JT", "YJ", "JX", "MA"), not(isnull(aa.contract_no))
│ │ │ │ └─TableScan_73	50894769.00	cop	table:aa, range:[-inf,+inf], keep order:false
│ │ │ └─TableReader_84	77337735.39	root	data:Selection_83
│ │ │ └─Selection_83	77337735.39	cop	eq(flow.status, "03"), lt(flow.date_rp, 2018-10-11 00:00:00.000000)
│ │ │ └─TableScan_82	182357418.00	cop	table:flow, range:[-inf,+inf], keep order:false
│ │ └─TableReader_86	23538851.00	root	data:TableScan_85
│ │ └─TableScan_85	23538851.00	cop	table:loan, range:[-inf,+inf], keep order:false
│ └─TableReader_89	1721677.00	root	data:Selection_88
│ └─Selection_88	1721677.00	cop	eq(aae.credit_ident, "Y")
│ └─TableScan_87	1721677.00	cop	table:aae, range:[-inf,+inf], keep order:false
└─Projection_90	8741510.44	root	uu.channel_id, cast(sub_channel), cast(activity_info), product_code, accu_loan_amt, cast(acct_repay_amt)
└─Projection_91	8741510.44	root	uu.channel_id, coalesce(uu.sub_channel, ""), coalesce(uu.activity_info, ""), case(and(not(isnull(aae.appl_no)), in(aa.product_code, "JT", "JX", "MA")), cast(or(cast(aa.product_code), 0)), aa.product_code), 12_col_0, 0
└─HashAgg_94	8741510.44	root	group by:case(and(not(isnull(aae.appl_no)), in(aa.product_code, "JT", "JX", "MA")), cast(or(cast(aa.product_code), 0)), aa.product_code), coalesce(uu.activity_info, ""), coalesce(uu.sub_channel, ""), uu.channel_id, funcs:sum(coalesce(loan.loan_amt, 0)), firstrow(uu.channel_id), firstrow(uu.sub_channel), firstrow(uu.activity_info), firstrow(aa.product_code), firstrow(aae.appl_no)
└─HashLeftJoin_100	13658610.06	root	left outer join, inner:TableReader_131, equal:[eq(aa.appl_no, aae.appl_no)]
├─HashRightJoin_107	13658610.06	root	inner join, inner:IndexJoin_111, equal:[eq(aa.contract_no, loan.contract_no)]
│ ├─IndexJoin_111	10926888.05	root	inner join, inner:IndexLookUp_110, outer key:aa.user_no, inner key:uu.user_no
│ │ ├─IndexLookUp_110	1.00	root	
│ │ │ ├─IndexScan_108	1.00	cop	table:uu, index:user_no, range: decided by [aa.user_no], keep order:false
│ │ │ └─TableScan_109	1.00	cop	table:cis_u_user, keep order:false
│ │ └─HashAgg_119	8741510.44	root	group by:col_4, col_5, col_6, col_7, funcs:firstrow(col_0), firstrow(col_1), firstrow(col_2), firstrow(col_3)
│ │ └─TableReader_120	8741510.44	root	data:HashAgg_114
│ │ └─HashAgg_114	8741510.44	cop	group by:aa.appl_no, aa.contract_no, aa.product_code, aa.user_no, funcs:firstrow(aa.appl_no), firstrow(aa.user_no), firstrow(aa.contract_no), firstrow(aa.product_code)
│ │ └─Selection_118	10926888.05	cop	eq(aa.appl_state, "APS"), in(aa.product_code, "JT", "YJ", "JX", "MA"), not(isnull(aa.contract_no))
│ │ └─TableScan_117	50894769.00	cop	table:aa, range:[-inf,+inf], keep order:false
│ └─TableReader_128	23538851.00	root	data:Selection_127
│ └─Selection_127	23538851.00	cop	lt(loan.date_created, 2018-10-11 00:00:00.000000)
│ └─TableScan_126	23538851.00	cop	table:loan, range:[-inf,+inf], keep order:false
└─TableReader_131	1721677.00	root	data:Selection_130
└─Selection_130	1721677.00	cop	eq(aae.credit_ident, "Y")
└─TableScan_129	1721677.00	cop	table:aae, range:[-inf,+inf], keep order:false

=============== 表结构===============
mysql> describe ln_loan;
+------------------+------------------+------+------+-------------------+-----------------------------+
| Field            | Type             | Null | Key  | Default           | Extra                       |
+------------------+------------------+------+------+-------------------+-----------------------------+
| id               | int(10) UNSIGNED | NO   | PRI  | NULL              | auto_increment              |
| loan_req_no      | varchar(64)      | NO   | UNI  | NULL              |                             |
| loan_no          | varchar(64)      | NO   | UNI  | NULL              |                             |
| busi_loan_no     | varchar(20)      | NO   |      | NULL              |                             |
| contract_no      | varchar(64)      | NO   | MUL  | NULL              |                             |
| cust_no          | varchar(64)      | NO   | MUL  | NULL              |                             |
| loan_amt         | decimal(17,2)    | NO   |      | NULL              |                             |
| term             | int(10) UNSIGNED | NO   |      | NULL              |                             |
| rpy_type         | varchar(2)       | NO   |      | NULL              |                             |
| date_loan        | datetime         | NO   |      | NULL              |                             |
| date_cash        | datetime         | YES  |      | NULL              |                             |
| date_inst        | date             | YES  |      | NULL              |                             |
| rp_day           | int(10) UNSIGNED | NO   |      | 0                 |                             |
| date_end         | date             | YES  |      | NULL              |                             |
| bank_code        | varchar(10)      | NO   |      | NULL              |                             |
| db_acct          | varchar(30)      | NO   |      | NULL              |                             |
| db_acct_name     | varchar(100)     | NO   |      | NULL              |                             |
| loan_source      | varchar(20)      | NO   |      | NULL              |                             |
| date_settle      | date             | YES  |      | NULL              |                             |
| date_bd          | date             | YES  |      | NULL              |                             |
| date_wo          | date             | YES  |      | NULL              |                             |
| date_accrued     | date             | YES  |      | NULL              |                             |
| date_compensate  | date             | YES  |      | NULL              |                             |
| over_due_days    | int(11) UNSIGNED | NO   |      | 0                 |                             |
| over_due_status  | varchar(10)      | YES  |      | M0                |                             |
| loan_bal         | decimal(17,2)    | NO   |      | 0.00              |                             |
| free_days        | int(11) UNSIGNED | YES  |      | 0                 |                             |
| date_stat        | date             | YES  |      | NULL              |                             |
| status           | varchar(2)       | NO   |      | NULL              |                             |
| accrual_type     | varchar(5)       | YES  |      | AC                |                             |
| compensate_type  | varchar(5)       | YES  |      | NCP               |                             |
| sub_product_ver  | int(11) UNSIGNED | NO   |      | NULL              |                             |
| sub_product_code | varchar(64)      | NO   |      |                   |                             |
| seq_no           | int(11) UNSIGNED | NO   |      | 1                 |                             |
| first_loan       | varchar(1)       | YES  |      | NULL              |                             |
| third_code       | varchar(64)      | NO   | MUL  |                   |                             |
| offer_req_no     | varchar(64)      | YES  |      | NULL              |                             |
| pay_order_no     | varchar(64)      | YES  |      | NULL              |                             |
| date_created     | timestamp        | NO   |      | CURRENT_TIMESTAMP |                             |
| created_by       | varchar(100)     | NO   |      | sys               |                             |
| date_updated     | timestamp        | NO   |      | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| updated_by       | varchar(100)     | NO   |      | sys               |                             |
+------------------+------------------+------+------+-------------------+-----------------------------+
mysql> describe tr_tran_proc_rp;
+-----------------+------------------+------+------+-------------------+-----------------------------+
| Field           | Type             | Null | Key  | Default           | Extra                       |
+-----------------+------------------+------+------+-------------------+-----------------------------+
| id              | int(10) UNSIGNED | NO   | PRI  | NULL              | auto_increment              |
| tran_proc_rp_no | varchar(64)      | NO   | UNI  | NULL              |                             |
| loan_no         | varchar(64)      | NO   | MUL  | NULL              |                             |
| contract_no     | varchar(64)      | NO   |      | NULL              |                             |
| cust_no         | varchar(64)      | YES  |      | NULL              |                             |
| rpy_type        | varchar(5)       | NO   |      | NULL              |                             |
| date_rp         | datetime         | NO   |      | CURRENT_TIMESTAMP |                             |
| date_tran       | date             | NO   |      | NULL              |                             |
| trans_amt       | decimal(17,2)    | NO   |      | NULL              |                             |
| trans_prin      | decimal(17,2)    | NO   |      | NULL              |                             |
| trans_int       | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_oint      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_deduct    | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_fee1      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_fee2      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_fee3      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_fee4      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_fee5      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| trans_fee6      | decimal(17,8)    | YES  |      | 0.00000000        |                             |
| bank_code       | varchar(10)      | NO   |      | NULL              |                             |
| rp_acct         | varchar(30)      | NO   |      | NULL              |                             |
| rp_acct_name    | varchar(100)     | NO   |      | NULL              |                             |
| pay_flag        | char(1)          | NO   |      | Y                 |                             |
| offer_req_no    | varchar(64)      | NO   | MUL  |                   |                             |
| status          | varchar(2)       | NO   |      | NULL              |                             |
| remark          | varchar(100)     | YES  |      | NULL              |                             |
| channel         | varchar(100)     | NO   |      | APP               |                             |
| rp_request_no   | varchar(64)      | NO   | MUL  |                   |                             |
| accrual_type    | varchar(20)      | YES  |      | AC                |                             |
| date_created    | timestamp        | NO   |      | CURRENT_TIMESTAMP |                             |
| created_by      | varchar(100)     | NO   |      | sys               |                             |
| date_updated    | timestamp        | NO   |      | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| updated_by      | varchar(100)     | NO   |      | sys               |                             |
+-----------------+------------------+------+------+-------------------+-----------------------------+
mysql> describe cis_u_user;
+-----------------+------------------+------+------+---------------------+-----------------------------+
| Field           | Type             | Null | Key  | Default             | Extra                       |
+-----------------+------------------+------+------+---------------------+-----------------------------+
| id              | int(10) UNSIGNED | NO   | PRI  | NULL                | auto_increment              |
| user_no         | varchar(64)      | NO   | UNI  |                     |                             |
| cust_no         | varchar(64)      | NO   | MUL  |                     |                             |
| device_no       | varchar(64)      | YES  |      | NULL                |                             |
| geo_no          | varchar(64)      | YES  |      | NULL                |                             |
| user_name       | varchar(100)     | YES  |      | NULL                |                             |
| user_pwd        | varchar(255)     | YES  |      | NULL                |                             |
| trans_pwd       | varchar(255)     | YES  |      | NULL                |                             |
| trans_pwd_flag  | char(1)          | YES  |      | NULL                |                             |
| salt            | varchar(100)     | YES  |      | NULL                |                             |
| mobile_no       | varchar(15)      | NO   | UNI  |                     |                             |
| division_code   | varchar(10)      | YES  |      | NULL                |                             |
| channel_id      | varchar(50)      | YES  |      | NULL                |                             |
| sub_channel     | varchar(64)      | YES  |      | NULL                |                             |
| activity_info   | varchar(500)     | YES  |      | NULL                |                             |
| register_source | varchar(50)      | NO   |      | NULL                |                             |
| host_app        | varchar(10)      | NO   |      | NULL                |                             |
| invitation_code | varchar(20)      | YES  |      | NULL                |                             |
| partner_id      | varchar(100)     | YES  |      | NULL                |                             |
| register_time   | datetime         | NO   | MUL  | CURRENT_TIMESTAMP   |                             |
| user_state      | char(1)          | NO   |      | 1                   |                             |
| expire_time     | datetime         | NO   |      | 9999-12-31 23:59:59 |                             |
| created_by      | varchar(100)     | NO   |      | sys                 |                             |
| date_created    | timestamp        | NO   |      | CURRENT_TIMESTAMP   |                             |
| updated_by      | varchar(100)     | NO   |      | sys                 |                             |
| date_updated    | timestamp        | NO   |      | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |
+-----------------+------------------+------+------+---------------------+-----------------------------+
mysql> describe lps_ap_appl;
+----------------+------------------+------+------+-------------------+-----------------------------+
| Field          | Type             | Null | Key  | Default           | Extra                       |
+----------------+------------------+------+------+-------------------+-----------------------------+
| id             | int(10) UNSIGNED | NO   | PRI  | NULL              | auto_increment              |
| appl_no        | varchar(64)      | NO   | UNI  |                   |                             |
| user_no        | varchar(64)      | NO   | MUL  |                   |                             |
| cust_no        | varchar(64)      | NO   | MUL  |                   |                             |
| flow_no        | varchar(64)      | NO   | MUL  |                   |                             |
| contract_no    | varchar(64)      | YES  |      | NULL              |                             |
| cust_name      | varchar(100)     | YES  |      | NULL              |                             |
| id_type        | char(1)          | YES  |      | NULL              |                             |
| id_no          | varchar(30)      | YES  |      | NULL              |                             |
| appl_amt       | decimal(17,2)    | YES  |      | NULL              |                             |
| appl_term      | int(11) UNSIGNED | YES  |      | NULL              |                             |
| credit_org     | varchar(10)      | NO   |      | THIRD_JS          |                             |
| apv_amt        | decimal(17,2)    | YES  |      | NULL              |                             |
| apv_time       | datetime         | YES  | MUL  | NULL              |                             |
| channel_id     | varchar(50)      | YES  |      | NULL              |                             |
| sub_channel    | varchar(64)      | YES  |      | NULL              |                             |
| appl_state     | varchar(5)       | NO   |      | NULL              |                             |
| appl_sub_state | varchar(20)      | YES  |      | NULL              |                             |
| avp_flag       | varchar(10)      | YES  |      | NULL              |                             |
| date_appl      | datetime         | NO   | MUL  | CURRENT_TIMESTAMP |                             |
| submit_time    | datetime         | YES  | MUL  | NULL              |                             |
| partner_code   | varchar(50)      | YES  |      | NULL              |                             |
| product_code   | varchar(50)      | NO   |      | NULL              |                             |
| purpose_no     | varchar(5)       | YES  |      | NULL              |                             |
| reason_code    | varchar(5)       | YES  |      | NULL              |                             |
| reason_desc    | varchar(100)     | YES  |      | NULL              |                             |
| credit_group   | varchar(20)      | YES  |      | NULL              |                             |
| date_created   | timestamp        | NO   |      | CURRENT_TIMESTAMP |                             |
| created_by     | varchar(100)     | NO   |      | sys               |                             |
| date_updated   | timestamp        | NO   |      | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| updated_by     | varchar(100)     | NO   |      | sys               |                             |
+----------------+------------------+------+------+-------------------+-----------------------------+
