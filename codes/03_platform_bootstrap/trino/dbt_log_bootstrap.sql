create schema if not exists iceberg.sample_db;

create table if not exists iceberg.sample_db.dbt_log (
    invocation_id  varchar,
    model_name     varchar,
    status         varchar,
    start_dt       timestamp(6) with time zone,
    end_dt         timestamp(6) with time zone,
    duration       varchar,
    error_message  varchar,
    run_info       varchar
)
with (
    format = 'PARQUET'
);
