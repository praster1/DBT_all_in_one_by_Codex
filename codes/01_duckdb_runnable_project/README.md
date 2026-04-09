# 01_duckdb_runnable_project

## 빠른 시작

1. Python 가상환경 생성
2. `pip install dbt-core dbt-duckdb duckdb`
3. `bootstrap/load_duckdb.py --db lab.duckdb --variant day1`
4. 아래 예시 profile을 `~/.dbt/profiles.yml`에 저장

```yml
dbt_all_in_one_lab:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: ./lab.duckdb
      threads: 4
```

5. `cd dbt_all_in_one_lab`
6. `dbt debug`
7. `dbt build --select retail`
8. `dbt build --select events`
9. `dbt build --select subscription`
10. snapshot 실습을 위해 `bootstrap/load_duckdb.py --db lab.duckdb --variant day2` 후 `dbt snapshot`

## 이 프로젝트 안의 세 트랙
- `models/retail/`
- `models/events/`
- `models/subscription/`

## 참고
- `snapshots/` 안의 snapshot은 legacy SQL 방식으로 넣었습니다. 책 본문과 `02_reference_patterns/`에서는 최신 YAML 기반 스냅샷 구성을 함께 소개합니다.
- `02_reference_patterns/semantic/`과 `02_reference_patterns/functions/`는 참고용이며, 실제 지원 범위는 dbt 버전/엔진/어댑터에 따라 달라질 수 있습니다.
