ALTER TABLE payments_for_parents
UPDATE money = 50000
WHERE id = 'recipe1' AND category = 'education' AND date = '2021-01-01';