<!-- Instructions for Cortex Code

Always read this file before performing any DBT-related task.
When asked to check or validate naming conventions, compare files against the standards defined in this document — do not infer conventions from existing files.


DBT Project Naming Conventions & Folder Structure

This document defines the standard naming conventions, folder structure, materialization defaults, and testing requirements for DBT development. Use this as context when generating DBT models with Snowflake Cortex Code.


Folder Structure
project/
├── models/
│   ├── sources/
│   │   └── <schema_name>/            # e.g. PUBLISH, RAW — confirm with user
│   │       └── src__<schema_name>__<table_name>.yml
│   ├── staging/
│   │   └── <schema_name>/
│   │       ├── stg__<schema_name>__<table_name>.sql
│   │       └── definitions/
│   │           └── stg__<schema_name>__<table_name>.yml
│   ├── intermediate/
│   │   └── <pipeline_folder>/
│   │       ├── int__<table_name>.sql
│   │       └── definitions/
│   │           └── int__<table_name>.yml
│   ├── marts/
│   │   └── <pipeline_folder>/
│   │       ├── fct__<table_name>.sql
│   │       ├── dim__<table_name>.sql
│   │       └── definitions/
│   │           ├── fct__<table_name>.yml
│   │           └── dim__<table_name>.yml
│   └── publish/
│       └── <user_defined_folder>/
│           ├── <user_defined_name>.sql
│           └── definitions/
│               └── <user_defined_name>.yml
├── macros/
│   └── mc__<macro_name>.sql
├── seeds/
│   └── sd__<table_name>.csv
└── snapshots/
    └── snp__<table_name>.yml

Naming Conventions

⚠️ Double-underscore rule: __ is always the separator between prefix, schema, and table name. Never use single underscores as separators. If the schema is RAW and table is raw_customers, the correct file name is src__RAW__raw_customers.yml — the RAW appearing twice is expected and correct; do not remove or deduplicate it.

LayerSQLYMLYML LocationSources—src__<SCHEMA>__<table>.ymlmodels/sources/<SCHEMA>/Stagingstg__<SCHEMA>__<table>.sqlstg__<SCHEMA>__<table>.ymlmodels/staging/<SCHEMA>/definitions/Intermediateint__<table>.sqlint__<table>.ymlmodels/intermediate/<pipeline>/definitions/Marts (fact)fct__<table>.sqlfct__<table>.ymlmodels/marts/<pipeline>/definitions/Marts (dim)dim__<table>.sqldim__<table>.ymlmodels/marts/<pipeline>/definitions/Publish<user_defined>.sql<user_defined>.ymlmodels/publish/<folder>/definitions/Seeds——seeds/sd__<table>.csvSnapshots—snp__<table>.ymlsnapshots/Macrosmc__<macro_name>.sql—macros/

Materialization & Tests
LayerMaterializationRequired TestsStagingviewunique, not_null (min 1 each)IntermediatetableNone mandatoryMartsincrementalunique, not_null (min 1 each)PublishviewNone mandatory

Behaviour Rules:
Always follow naming conventions in this doc.
Ask before creating intermediate and marts files if pipeline/subfolder is not specified. Always ask for both folder name and model name before creating any publish files.
One YML file per source table — never combine tables.
YML definitions always go in the definitions/ subfolder relative to the SQL file.
Auto-apply unique + not_null tests in staging and marts YML files.
Source subfolder must match the schema name — confirm with user if not specified.
Never rename or alias columns in staging unless explicitly asked.
Macro names are always provided by the user — ask if not specified. -->


Instructions for Cortex Code

Always read this file before performing any DBT-related task.
When asked to check or validate naming conventions, compare files against the standards defined in this document — do not infer conventions from existing files.


DBT Project Naming Conventions & Folder Structure

This document defines the standard naming conventions, folder structure, materialization defaults, and testing requirements for DBT development. Use this as context when generating DBT models with Snowflake Cortex Code.


Folder Structure
project/
├── models/
│   ├── sources/
│   │   └── [schema_name]/            # e.g. PUBLISH, RAW — confirm with user
│   │       └── src__[schema_name]__[table_name].yml
│   ├── staging/
│   │   └── [schema_name]/
│   │       ├── stg__[schema_name]__[table_name].sql
│   │       └── definitions/
│   │           └── stg__[schema_name]__[table_name].yml
│   ├── intermediate/
│   │   └── [pipeline_folder]/
│   │       ├── int__[table_name].sql
│   │       └── definitions/
│   │           └── int__[table_name].yml
│   ├── marts/
│   │   └── [pipeline_folder]/
│   │       ├── fct__[table_name].sql
│   │       ├── dim__[table_name].sql
│   │       └── definitions/
│   │           ├── fct__[table_name].yml
│   │           └── dim__[table_name].yml
│   └── publish/
│       └── [user_defined_folder]/
│           ├── [user_defined_name].sql
│           └── definitions/
│               └── [user_defined_name].yml
├── macros/
│   └── mc__[macro_name].sql
├── seeds/
│   └── sd__[table_name].csv
└── snapshots/
    └── snp__[table_name].yml

Layer-by-Layer Conventions
1. Sources

Location: models/sources/[schema_name]/
Subfolders: Named after the schema being consumed (e.g. PUBLISH, RAW, LANDING).
Schema rule: Default subfolder name is the schema name. If the user does not specify the schema or subfolder name, always confirm before creating files.
One file per table — each source table has its own individual YML file.
Naming: src__[folder_name]__[table_name].yml
Example:

  models/sources/PUBLISH/src__PUBLISH__customer.yml
  models/sources/RAW/src__RAW__raw_orders.yml
2. Staging

Location: models/staging/[schema_name]/
Subfolders: Follow the same schema-based pattern as the source YML subfolders.
SQL naming: stg__[folder_name]__[table_name].sql
YML naming: stg__[folder_name]__[table_name].yml
YML location: Inside a definitions/ subfolder within the staging subfolder.
Materialization: view
Testing: At least one unique and one not_null test must be defined per model.
Example:

  models/staging/PUBLISH/stg__PUBLISH__customer.sql
  models/staging/PUBLISH/definitions/stg__PUBLISH__customer.yml
3. Intermediate

Location: models/intermediate/[pipeline_folder]/
Subfolders: Named after the pipeline of the target table.
SQL naming: int__[table_name].sql
YML naming: int__[table_name].yml
YML location: Inside a definitions/ subfolder within the pipeline subfolder.
Materialization: table
⚠️ Cortex Instruction: If the user does not specify the pipeline folder location, always ask before creating any files.
Example:

  models/intermediate/customer_pipeline/int__customer_enriched.sql
  models/intermediate/customer_pipeline/definitions/int__customer_enriched.yml
4. Marts

Location: models/marts/[pipeline_folder]/
Subfolders: Named after the pipeline of the target table.
SQL naming: Fact tables: fct__[table_name].sql / Dimension tables: dim__[table_name].sql
YML naming: fct__[table_name].yml / dim__[table_name].yml
YML location: Inside a definitions/ subfolder within the pipeline subfolder.
Materialization: incremental
Testing: At least one unique and one not_null test must be defined per model.
⚠️ Cortex Instruction: If the user does not specify the pipeline folder location, always ask before creating any files.
Example:

  models/marts/customer_pipeline/fct__customer_orders.sql
  models/marts/customer_pipeline/dim__customer.sql
  models/marts/customer_pipeline/definitions/fct__customer_orders.yml
  models/marts/customer_pipeline/definitions/dim__customer.yml
5. Publish

Location: models/publish/[user_defined_folder]/
Subfolders: Defined by the user.
SQL naming: Defined by the user.
YML naming: Same name as the SQL model, with .yml extension.
YML location: Inside a definitions/ subfolder within the user-defined subfolder.
Materialization: view
⚠️ Cortex Instruction: Always ask the user for the folder name and model name before creating any files in this layer.
Example:

  models/publish/reporting/monthly_sales.sql
  models/publish/reporting/definitions/monthly_sales.yml
6. Seeds

Location: seeds/
Naming: sd__[table_name].csv
Example:

  seeds/sd__country_codes.csv
  seeds/sd__product_categories.csv
7. Snapshots

Location: snapshots/
Naming: snp__[table_name].yml
Example:

  snapshots/snp__customer.yml
  snapshots/snp__product.yml
8. Macros

Location: macros/
Naming: mc__[macro_name].sql
⚠️ Cortex Instruction: The macro name is always provided by the user. Always ask if not specified.
Example:

  macros/mc__generate_schema_name.sql
  macros/mc__cents_to_dollars.sql

Naming Conventions

⚠️ Double-underscore rule: __ is always the separator between prefix, schema, and table name. Never use single underscores as separators. If the schema is RAW and table is raw_customers, the correct file name is src__RAW__raw_customers.yml — the RAW appearing twice is expected and correct; do not remove or deduplicate it.

LayerSQLYMLYML LocationSources—src__[SCHEMA]__[table].ymlmodels/sources/[SCHEMA]/Stagingstg__[SCHEMA]__[table].sqlstg__[SCHEMA]__[table].ymlmodels/staging/[SCHEMA]/definitions/Intermediateint__[table].sqlint__[table].ymlmodels/intermediate/[pipeline]/definitions/Marts (fact)fct__[table].sqlfct__[table].ymlmodels/marts/[pipeline]/definitions/Marts (dim)dim__[table].sqldim__[table].ymlmodels/marts/[pipeline]/definitions/Publish[user_defined].sql[user_defined].ymlmodels/publish/[folder]/definitions/Seeds——seeds/sd__[table].csvSnapshots—snp__[table].ymlsnapshots/Macrosmc__[macro_name].sql—macros/

Materialization & Tests
LayerMaterializationRequired TestsStagingviewunique, not_null (min 1 each)IntermediatetableNone mandatoryMartsincrementalunique, not_null (min 1 each)PublishviewNone mandatory

Behaviour Rules

Always follow naming conventions in this doc.
Ask before creating intermediate and marts files if pipeline/subfolder is not specified. Always ask for both folder name and model name before creating any publish files.
One YML file per source table — never combine tables.
YML definitions always go in the definitions/ subfolder relative to the SQL file. This applies to staging, intermediate, marts, and publish layers.
Auto-apply unique + not_null tests in staging and marts YML files.
Source subfolder must match the schema name — confirm with user if not specified.
Never rename or alias columns in staging unless explicitly asked.
Macro names are always provided by the user — ask if not specified.