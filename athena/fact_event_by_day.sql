CREATE EXTERNAL TABLE IF NOT EXISTS spa2.fact_event_by_day (
  `event_pk` bigint,
  `space_pk` int,
  `local_date_pk` int,
  `space_calendar_pk` bigint,
  `company_pk` int,
  `local_scheduled_start_time_pk` int,
  `local_scheduled_end_time_pk` int,
  `local_actual_start_time_pk` int,
  `local_actual_end_time_pk` int,
  `timezone_pk` bigint,
  `event_by_day_pk` bigint,
  `event_by_day_checkin_ctr` smallint,
  `event_by_day_cancel_method` string,
  `event_by_day_cancelled_at` timestamp,
  `event_by_day_local_scheduled_start_time` timestamp,
  `event_by_day_local_scheduled_end_time` timestamp,
  `event_by_day_local_actual_start_time` timestamp,
  `event_by_day_local_actual_end_time` timestamp,
  `event_by_day_local_series_original_start_time` timestamp,
  `event_by_day_end_early_flag` boolean,
  `event_by_day_recapture_dur` int,
  `event_by_day_platform_url` string,
  `event_by_day_status` string,
  `event_by_day_is_private_flag` boolean,
  `event_by_day_is_ad_hoc_flag` boolean,
  `event_by_day_multi_day_flag` boolean,
  `event_by_day_first_day_flag` boolean,
  `event_by_day_last_day_flag` boolean,
  `event_by_day_source_created_at` timestamp,
  `event_by_day_source_updated_at` timestamp,
  `edw_event_by_day_company_id` int,
  `edw_event_by_day_hash_update` string,
  `edw_event_by_day_hash_insert` string,
  `edw_event_by_day_process_name` string,
  `edw_event_by_day_process_filename` string,
  `edw_event_by_day_job_name` string,
  `edw_event_by_day_created_at` timestamp,
  `edw_event_by_day_updated_at` timestamp 
)
PARTITIONED BY (created_date date)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://spa-etl-test/migration-test/parquet/fact_event_by_day/'
TBLPROPERTIES ('has_encrypted_data'='false', "parquet.compress"="SNAPPY");

MSCK REPAIR TABLE spa2.fact_event_by_day;