CREATE TABLE IF NOT EXISTS source(
    value String
) ENGINE Memory;

CREATE TABLE counters (
    id String,
    counter Int64
) ENGINE = SummingMergeTree();

CREATE MATERIALIZED VIEW IF NOT EXISTS counters_view TO counters AS
    SELECT
        JSONExtractString(value, 'id') AS id,
        JSONExtractInt(value, 'value') AS counter
    FROM source
    WHERE JSONExtractString(value, 'type') = 'counter';

SELECT id, counter FROM counters FINAL;