CREATE TABLE IF NOT EXISTS source(
                                     value String
) ENGINE Memory;

CREATE TABLE IF NOT EXISTS payments_for_parents (
                                        id String,
                                        date DATE,
                                        category String,
                                        purpose String,
                                        money Int64,
                                        idx Int64
) ENGINE = ReplacingMergeTree(idx)
    ORDER BY (date, category, id);

CREATE MATERIALIZED VIEW payment_for_parents_view TO payments_for_parents AS
    SELECT
        JSONExtractString(value, 'id') AS id,
        toDate(JSONExtract(toString(value), 'date', 'String')) AS date,
        JSONExtractString(value, 'category') AS category,
        JSONExtractString(value, 'purpose') AS purpose,
        JSONExtractInt(value, 'money') AS money,
        JSONExtractInt(value, 'index') AS idx
    FROM source
    WHERE JSONExtractString(value, 'type') = 'payment' AND category NOT IN ('games', 'useless')