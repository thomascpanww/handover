CREATE EXTERNAL TABLE IF NOT EXISTS spa2.fact_attendance (
  `event_pk` bigint,
  `calendar_pk` bigint,
  `attendance_pk` bigint,
  `attendance_role` string,
  `attendance_status` string,
  `edw_attendance_hash_update` string,
  `edw_attendance_hash_insert` string,
  `edw_attendance_process_name` string,
  `edw_attendance_process_filename` string,
  `edw_attendance_job_name` string,
  `edw_attendance_created_at` timestamp,
  `edw_attendance_updated_at` timestamp
)
PARTITIONED BY (created_date date)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://spa-etl-test/migration-test/parquet/fact_attendance/'
TBLPROPERTIES ('has_encrypted_data'='false', "parquet.compress"="SNAPPY");

MSCK REPAIR TABLE spa2.fact_attendance;