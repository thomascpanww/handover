CREATE EXTERNAL TABLE IF NOT EXISTS spa2.dim_space (
  `space_pk` int,
  `space_id` int,
  `space_type` string,
  `space_name` string,
  `space_current_name` string,
  `space_floor_id` int,
  `space_floor_name` string,
  `space_building_id` int,
  `space_building_name` string,
  `space_campus_id` int,
  `space_campus_name` string,
  `space_calendar_is_attached_flag` boolean,
  `space_calendar_uuid` string,
  `space_capacity` int,
  `space_timezone` string,
  `space_checkin_enabled_flag` boolean,
  `space_source_created_at` timestamp,
  `space_source_updated_at` timestamp,
  `space_source_deleted_at` timestamp,
  `edw_space_company_id` int,
  `edw_space_crc_update` bigint,
  `edw_space_crc_insert` bigint,
  `edw_space_eff_start_at` timestamp,
  `edw_space_eff_end_at` timestamp,
  `edw_space_is_current_flag` boolean,
  `edw_space_process_name` string,
  `edw_space_process_filename` string,
  `edw_space_job_name` string,
  `edw_space_created_at` timestamp,
  `edw_space_updated_at` timestamp
)
PARTITIONED BY (created_date date)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://spa-etl-test/migration-test/parquet/dim_space/'
TBLPROPERTIES ('has_encrypted_data'='false', "parquet.compress"="SNAPPY");

MSCK REPAIR TABLE spa2.dim_space;