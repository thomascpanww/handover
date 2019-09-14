CREATE EXTERNAL TABLE IF NOT EXISTS spa2.dim_date (
  `date_pk` int,
  `day_date` date,
  `day_timestamp` timestamp,
  `date_display_mmddyyyy` char,
  `date_display_ddmmyyyy` char,
  `date_display_yyyymm` char,
  `date_display_month_year` char,
  `day_of_month_num` smallint,
  `day_of_month_num_with_suffix` string,
  `day_name` string,
  `day_of_week_num_usa` smallint,
  `day_of_week_num_iso` smallint,
  `day_instance_in_month_ctr` smallint,
  `day_instance_in_year_ctr` smallint,
  `day_of_quarter_num` smallint,
  `day_of_year_num` smallint,
  `month_week_num` smallint,
  `quarter_week_num` smallint,
  `year_week_num` smallint,
  `month_num` smallint,
  `month_name` string,
  `quarter_month_num` smallint,
  `quarter_num` smallint,
  `quarter_name` char,
  `year_num` smallint,
  `year_name` char,
  `first_day_of_month` date,
  `last_day_of_month` date,
  `first_day_of_quarter` date,
  `last_day_of_quarter` date,
  `first_day_of_year` date,
  `last_day_of_year` date,
  `is_weekday_flag` boolean,
  `is_holiday_usa_flag` boolean,
  `holiday_name_usa` string,
  `edw_date_process_name` string,
  `edw_date_process_filename` string,
  `edw_date_job_name` string,
  `edw_date_created_at` timestamp,
  `edw_date_updated_at` timestamp
)
PARTITIONED BY (created_date date)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://spa-etl-test/migration-test/parquet/dim_date/'
TBLPROPERTIES ('has_encrypted_data'='false', "parquet.compress"="SNAPPY");

MSCK REPAIR TABLE spa2.dim_date;