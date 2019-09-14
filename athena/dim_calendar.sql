CREATE EXTERNAL TABLE IF NOT EXISTS spa2.dim_calendar (
  `calendar_pk` bigint,
  `calendar_uuid` string,
  `calendar_identifier` string,
  `calendar_type` string,
  `calendar_web_domain` string,
  `calendar_email` string,
  `calendar_account_id` int,
  `calendar_name` string,
  `calendar_timezone` string,
  `calendar_platform` string,
  `calendar_platform_version` string,
  `calendar_source_created_at` timestamp,
  `calendar_source_updated_at` timestamp,
  `edw_calendar_identifier_is_active_flag` boolean,
  `edw_calendar_source_table` string,
  `edw_calendar_company_id` int,
  `edw_calendar_hash_update` string,
  `edw_calendar_hash_insert` string,
  `edw_calendar_eff_start_at` timestamp,
  `edw_calendar_eff_end_at` timestamp,
  `edw_calendar_is_current_flag` boolean,
  `edw_calendar_process_name` string,
  `edw_calendar_process_filename` string,
  `edw_calendar_job_name` string,
  `edw_calendar_created_at` timestamp,
  `edw_calendar_updated_at` timestamp
)
PARTITIONED BY (created_date date)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://spa-etl-test/migration-test/parquet/dim_calendar/'
TBLPROPERTIES ('has_encrypted_data'='false', "parquet.compress"="SNAPPY");

MSCK REPAIR TABLE spa2.dim_calendar;