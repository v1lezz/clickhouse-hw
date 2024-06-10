CREATE TABLE IF NOT EXISTS source(
    value String
) ENGINE Memory;

CREATE TABLE IF NOT EXISTS payments (
    id String,
    date DATE,
    category String,
    purpose String,
    money Int64,
    idx Int64
) ENGINE = ReplacingMergeTree(idx)
ORDER BY (date, category, id);

CREATE MATERIALIZED VIEW payments_view TO payments AS
    SELECT
        JSONExtractString(value, 'id') AS id,
        toDate(JSONExtract(toString(value), 'date', 'String')) AS date,
        JSONExtractString(value, 'category') AS category,
        JSONExtractString(value, 'purpose') AS purpose,
        JSONExtractInt(value, 'money') AS money,
        JSONExtractInt(value, 'index') AS idx
    FROM source
    WHERE JSONExtractString(value, 'type') = 'payment';

SELECT category, sum(money) FROM payments FINAL GROUP BY category;