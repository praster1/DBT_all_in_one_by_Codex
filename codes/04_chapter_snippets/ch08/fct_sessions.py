def model(dbt, session):
    dbt.config(materialized="table")

    events = dbt.ref("stg_events")

    # Example-only pseudocode. Adapter-specific DataFrame APIs differ.
    sessions = (
        events
        .sort_values(["user_id", "event_at"])
        .assign(session_boundary=lambda df: (df["gap_minutes"] > 30).astype(int))
    )

    return sessions
