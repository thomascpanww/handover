# Handover

# TLDR
- spark job:
	- complete:
		- csv to parquet conversion
		- snapshot migration
		- incremental migration
		- postgres migration
	- incomplete:
		- agg_hourly_space: 99% done. Last run resulted in a discrepancy of 0.4%
		- week_people_count: not complete
- meastro-spa PR #71 should be good to merge.
- meastro-spa PR #49 should be good to merge. Worked last time I tested. 
- See below for more details

# maestro-spa

## Pull Requests

### Add teem weekly job alerts. #71
Link: https://github.com/WeConnect/maestro-spa/pull/71
Objective: Add email & slack alert to copy teem day weekly job.
- Summary: 
- Done.
- Simple change. Should have little to no risk of merging. 

### Aggregate data check #49

Link: [https://github.com/WeConnect/maestro-spa/pull/49](https://github.com/WeConnect/maestro-spa/pull/49)
Objective: Check company_ids and data within 95% before running aggregation job.
Summary:
-   Done.
-   company_id check not included since not all companies are present.

### New migration flow #77

Link: [https://github.com/WeConnect/maestro-spa/pull/77](https://github.com/WeConnect/maestro-spa/pull/77)
Objective: New migration flow. Pipeline starts from TEEM csv files and ends at Postgresql.
Notes:
#### Redshift Unload Settings
Unload settings assumed for spark/athena to read csv.
```
UNLOAD ('select * from teem_edw.dim_company') 
TO 's3://spa-etl-test/migration-test/csv/dim_company/snapshot/dim_company_'
ALLOWOVERWRITE
DELIMITER '|'
NULL AS '\\N'
ESCAPE
ADDQUOTES 
PARALLEL ON 
ACCESS_KEY_ID ''
SECRET_ACCESS_KEY '' 
SESSION_TOKEN ''
REGION 'us-west-1'
MAXFILESIZE AS 256 MB;
```
#### S3 Directory Structure
Directory structure assumed for spark/athena.
```
.
+-- root
|   +-- csv
|   	+-- dim_calendar
|   	+-- dim_company
|   	+-- ...
|   +-- jars
|   	+-- csv-to-parquet.jar
|   	+-- postgresql-42.2.6.jar
+-- _includes
|   +-- parquet
|   	+-- dim_calendar
|   		+-- created_date=...
|   		+-- ...
|   	+-- dim_company
|   		+-- created_date=...
|   		+-- ...
|   	+-- ...
|   +-- scripts
|   	+-- script.sh
```
#### Configs
See handover repo
- migrate_daily_teem_data.json
	- variables needed for job.
- aws_wwss_thomas_pan_conn.json
	- currently pass credentials in extra part of aws conn.
	- template correct but will need to be adjusted. 
- emr_spark_www_conn.json
	- extra for emr_conn

#### Remaining Issues
- week_people_count aggregate query incomplete
	- See handover repo
		- spa_spark_pipelines/csv/redshift.csv and spa_spark_pipelines/csv/spark.csv shows latest results from redshift and spark query. 
		- redshift: 8788 rows
		- spark: 8791 rows
		- spark has a 3 more rows and there are is a data discrepancy of around 0.4%. Rows don't match up exactly. 
- hourly_space mostly complete. There seems to be an issue with timezones. DATA timestamps are in UTC, but EMR timezone is currently set as PST. There is a consistent 7 hour offset in results. Spark does automatic conversion to local timezone. However, setting ``spark.sql.session.timeZone=UTC`` does not seem to address the issue. It is unclear when it does this conversion and whether it "unconverts" it when writing. 
- Currently manually generating tokens via okta-aws. 
- To write to JDBC, need to include postgres driver.
	- However, adding it to the class path overrides it instead of adding it. I had to hardcode the default class path and manually append the driver 
	- EMR doesn't seem to be able to read the postgres.jar when its on s3. Need to add a bootstrap step to load jar file into all containers. 
- Need to add aggregate data check logic to job. "Aggregate data check #49" won't work anymore. 
- Airflow DAG currently **does not** have logic to shut off EMR if something goes wrong. 

## Other
- I made a change a while back that should fix the airflow hyperlink issues. I believe Matt mentioned that something was wrong with production at the time. Maybe should reset, Joe Nap. would probably know how to fix it. 

# spa-spark-pipelines-2

## Pull Requests

### Csv to parquet #1

Link: [https://github.com/thomascpanww/spa-spark-pipelines-2/pull/1](https://github.com/thomascpanww/spa-spark-pipelines-2/pull/1)
Objective: Create spark jobs to convert csv to parquet, migrate to postgres, and run aggregation jobs. 
Notes:
#### Remaining Issues
- See "remaining issues" for "maestro-spa"
- Code needs refactoring and testing. 

# Athena
Link: [https://github.com/thomascpanww/spa-spark-pipelines-2/pull/1](https://github.com/thomascpanww/spa-spark-pipelines-2/pull/1)
Objective: Create spark jobs to convert csv to parquet, migrate to postgres, and run aggregation jobs. 
Notes:
- Athena is extremely easy to set up. As long as the parquet files are created via the spa-spark-pipelines csvToParquet converter, it should work. 
- Athena can also work with CSV and various other formats, but I recommend using parquet due to speed and cost benefits. 
- See handover repo: includes athena folder that has DDL on how to create athena tables from parquet files.
- ``MSCK REPAIR TABLE spa2.dim_calendar;`` Also needs to be run every time new partitions are added. 

# Flink
Link: [https://github.com/WeConnect/spa-flink-pipelines/tree/hourly-space](https://github.com/WeConnect/spa-flink-pipelines/tree/hourly-space)
Objective: Translate existing aggregation jobs into Flink jobs. 
Notes:
- Incomplete. 
- Issues
	- Data Source: 
		- Initially, experienced issues with CSV format. After getting access on how Redshift exports its data, I think these issues could be partially resolved, but Spark required a lot of custom CSV parsing options. Not sure if Flink has all these options available. 
		- Since the native CSV parser didn't work, I eventually started to build my own line by line parser. 
	- SQL Table API/SQL
		- Flink uses the Apache Calcite, and Flink currently only supports a subset of features available on Calcite.
		- Most notably, Flink does not support:
			- ROW_NUMBER
			- non equi-join
		- Documentation specifically states that TABLE API/SQL are incomplete. 
	- DataSet API
		- Supports 3 main types:
			- Tuples
				- Does not support null data
			- Rows
				- Supports null data, but #readCsvFile does not support rows.
			- POJOs
				- Supports null data, but can't read null or blank fields from CSV.
				- Also can't read certain timestamps.
-	Conclusion
	-	See hourly_space branch for latest attempt to use Flink.
	-	Two possibilities:
		-	1
			-	Either I misunderstood how to use Flink completely and it should be easy to parse csv and write a query.
		-	2
			-	Create customer parser that manually parses CSV line by line.
			-	Use SQL API to do 90% of work.
			-	Write non equi-join via DataSet API.
-	Misc
	-	Data Platform team suggested using AVRO.
	-	Theres a maven tool that can create the POJO for you. However, this ended up not making sense because we wanted to use CSV/Parquet. 


# HBase

Link: [https://github.com/thomascpanww/hbasetest](https://github.com/thomascpanww/hbasetest)
Objective: Create HBase standalone.
Notes:
- A simple HBase project that creates a table, imports data, gets, filters, and deletes table. Specifially AggHourlySpace.
- However, I believe it was using Postico exported CSV for this project. 
