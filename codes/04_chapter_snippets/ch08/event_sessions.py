def model(dbt, session):
    dbt.config(materialized="table")

    events = dbt.ref("stg_events")

    # 실제 구현에서는 adapter별 DataFrame API에 맞게 조정한다.
    sessions = (
        events
        .groupBy("user_id", "session_id")
        .agg({"event_at": "min"})
    )

    return sessions
