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
#### Remaining Issues
- week_people_count aggregate query incomplete
- hourly_space mostly complete. There seems to be an issue with timezones. DATA timestamps are in UTC, but EMR timezone is currently set as PST. There is a consistent 7 hour offset in results. Spark does automatic conversion to local timezone. However, setting ``spark.sql.session.timeZone=UTC`` does not seem to address the issue. It is unclear when it does this conversion and whether it "unconverts" it when writing. 

# spa-spark-pipelines-2

Synchronization is one of the biggest features of StackEdit. It enables you to synchronize any file in your workspace with other files stored in your **Google Drive**, your **Dropbox** and your **GitHub** accounts. This allows you to keep writing on other devices, collaborate with people you share the file with, integrate easily into your workflow... The synchronization mechanism takes place every minute in the background, downloading, merging, and uploading file modifications.

There are two types of synchronization and they can complement each other:

- The workspace synchronization will sync all your files, folders and settings automatically. This will allow you to fetch your workspace on any other device.
	> To start syncing your workspace, just sign in with Google in the menu.

- The file synchronization will keep one file of the workspace synced with one or multiple files in **Google Drive**, **Dropbox** or **GitHub**.
	> Before starting to sync files, you must link an account in the **Synchronize** sub-menu.

## Open a file

You can open a file from **Google Drive**, **Dropbox** or **GitHub** by opening the **Synchronize** sub-menu and clicking **Open from**. Once opened in the workspace, any modification in the file will be automatically synced.

## Save a file

You can save any file of the workspace to **Google Drive**, **Dropbox** or **GitHub** by opening the **Synchronize** sub-menu and clicking **Save on**. Even if a file in the workspace is already synced, you can save it to another location. StackEdit can sync one file with multiple locations and accounts.

## Synchronize a file

Once your file is linked to a synchronized location, StackEdit will periodically synchronize it by downloading/uploading any modification. A merge will be performed if necessary and conflicts will be resolved.

If you just have modified your file and you want to force syncing, click the **Synchronize now** button in the navigation bar.

> **Note:** The **Synchronize now** button is disabled if you have no file to synchronize.

## Manage file synchronization

Since one file can be synced with multiple locations, you can list and manage synchronized locations by clicking **File synchronization** in the **Synchronize** sub-menu. This allows you to list and remove synchronized locations that are linked to your file.


# Athena

Publishing in StackEdit makes it simple for you to publish online your files. Once you're happy with a file, you can publish it to different hosting platforms like **Blogger**, **Dropbox**, **Gist**, **GitHub**, **Google Drive**, **WordPress** and **Zendesk**. With [Handlebars templates](http://handlebarsjs.com/), you have full control over what you export.

> Before starting to publish, you must link an account in the **Publish** sub-menu.

## Publish a File

You can publish your file by opening the **Publish** sub-menu and by clicking **Publish to**. For some locations, you can choose between the following formats:

- Markdown: publish the Markdown text on a website that can interpret it (**GitHub** for instance),
- HTML: publish the file converted to HTML via a Handlebars template (on a blog for example).

## Update a publication

After publishing, StackEdit keeps your file linked to that publication which makes it easy for you to re-publish it. Once you have modified your file and you want to update your publication, click on the **Publish now** button in the navigation bar.

> **Note:** The **Publish now** button is disabled if your file has not been published yet.

## Manage file publication

Since one file can be published to multiple locations, you can list and manage publish locations by clicking **File publication** in the **Publish** sub-menu. This allows you to list and remove publication locations that are linked to your file.


# Flink

StackEdit extends the standard Markdown syntax by adding extra **Markdown extensions**, providing you with some nice features.

> **ProTip:** You can disable any **Markdown extension** in the **File properties** dialog.


## SmartyPants

SmartyPants converts ASCII punctuation characters into "smart" typographic punctuation HTML entities. For example:

|                |ASCII                          |HTML                         |
|----------------|-------------------------------|-----------------------------|
|Single backticks|`'Isn't this fun?'`            |'Isn't this fun?'            |
|Quotes          |`"Isn't this fun?"`            |"Isn't this fun?"            |
|Dashes          |`-- is en-dash, --- is em-dash`|-- is en-dash, --- is em-dash|


## KaTeX

You can render LaTeX mathematical expressions using [KaTeX](https://khan.github.io/KaTeX/):

The *Gamma function* satisfying $\Gamma(n) = (n-1)!\quad\forall n\in\mathbb N$ is via the Euler integral

$$
\Gamma(z) = \int_0^\infty t^{z-1}e^{-t}dt\,.
$$

> You can find more information about **LaTeX** mathematical expressions [here](http://meta.math.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference).


## UML diagrams

You can render UML diagrams using [Mermaid](https://mermaidjs.github.io/). For example, this will produce a sequence diagram:

```mermaid
sequenceDiagram
Alice ->> Bob: Hello Bob, how are you?
Bob-->>John: How about you John?
Bob--x Alice: I am good thanks!
Bob-x John: I am good thanks!
Note right of John: Bob thinks a long<br/>long time, so long<br/>that the text does<br/>not fit on a row.

Bob-->Alice: Checking with John...
Alice->John: Yes... John, how are you?
```

And this will produce a flow chart:

```mermaid
graph LR
A[Square Rect] -- Link text --> B((Circle))
A --> C(Round Rect)
B --> D{Rhombus}
C --> D
```
