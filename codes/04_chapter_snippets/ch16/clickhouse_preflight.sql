-- 1) 연결 및 버전 확인
select version() as clickhouse_version, currentDatabase() as current_database;

-- 2) 주요 테이블 상태 확인
select
  database,
  table,
  engine,
  total_rows,
  total_bytes
from system.tables
where database = 'analytics'
order by table;

-- 3) 파트 상태 확인
select
  database,
  table,
  count() as active_parts,
  sum(rows) as rows_in_parts
from system.parts
where active = 1
  and database = 'analytics'
group by database, table
order by table;
