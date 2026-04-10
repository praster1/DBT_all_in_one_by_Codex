-- Replace schema/table names as needed.
-- Goal: confirm that the merge unique_key exists in both source and target surfaces.

-- 1) Source branch must expose the unique key
WITH source_branch AS (
    SELECT
        id,
        run_status
    FROM iceberg.sample_db.case03_branch_query
)
SELECT
    count(*) AS src_rows,
    count(id) AS src_non_null_id
FROM source_branch;

-- 2) Target relation must also contain the unique key column
DESCRIBE iceberg.sample_db.case03_branch_query;
