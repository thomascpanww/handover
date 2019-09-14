CREATE EXTERNAL TABLE IF NOT EXISTS spa2.dim_company (
  `company_pk` int,
  `company_id` int,
  `company_name` string,
  `company_is_active_flag` boolean,
  `company_desired_util_pct` int,
  `company_include_weekends_flag` boolean,
  `company_exclude_all_day_flag` boolean,
  `company_hours_start` string,
  `company_hours_end` string,
  `company_daily_operating_hours` float,
  `company_source_created_at` timestamp,
  `company_source_updated_at` timestamp,
  `edw_company_exp_at` timestamp,
  `edw_company_crc_update` bigint,
  `edw_company_crc_insert` bigint,
  `edw_company_eff_start_at` timestamp,
  `edw_company_eff_end_at` timestamp,
  `edw_company_is_current_flag` boolean,
  `edw_company_process_name` string,
  `edw_company_process_filename` string,
  `edw_company_job_name` string,
  `edw_company_created_at` timestamp,
  `edw_company_updated_at` timestamp
)
PARTITIONED BY (created_date date)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://spa-etl-test/migration-test/parquet/dim_company/'
TBLPROPERTIES ('has_encrypted_data'='false', "parquet.compress"="SNAPPY");

MSCK REPAIR TABLE spa2.dim_company;