# Handover

Hi! I'm your first Markdown file in **StackEdit**. If you want to learn about StackEdit, you can read me. If you want to play with Markdown, you can edit me. Once you have finished with me, you can create new files by opening the **file explorer** on the left corner of the navigation bar.


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
- hourly_space mostly complete. There seems to be an issue with timezones. DATA timestamps are in UTC, but EMR timezone is currently set as PST. There is a consistent 7 hour offset in results. Spark does automatic conversion to local timezone. However, setting ``spark.sql.session.timeZone=UTC`` does not seem to address the issue. It is unclear when it does this conversion and whether it "unconverts" it when writing. 
- Currently manually generating tokens via okta-aws. 

# spa-spark-pipelines-2

### Csv to parquet #1

Link: [https://github.com/thomascpanww/spa-spark-pipelines-2/pull/1](https://github.com/thomascpanww/spa-spark-pipelines-2/pull/1)
Objective: Create spark jobs to convert csv to parquet, migrate to postgres, and run aggregation jobs. 
Notes:
#### Remaining Issues
- See "remaining issues" for "maestro-spa"
- Code needs refactoring and testing. 

# Athena


# Flink
