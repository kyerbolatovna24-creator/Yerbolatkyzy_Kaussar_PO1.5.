SELECT *
FROM payment
WHERE amount = 0.00;

-- Delete rows
DELETE FROM payment
WHERE amount = 0.00;

-- Verify deletion
SELECT COUNT(*) AS remaining_zero_payments
FROM payment
WHERE amount = 0.00;