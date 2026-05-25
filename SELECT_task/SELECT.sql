SELECT
    c.first_name,
    c.last_name,
    a.district
FROM customer c
JOIN address a
    ON c.address_id = a.address_id
WHERE a.district ILIKE '%texas%'
ORDER BY c.last_name;


SELECT
    f.title,
    f.length,
    cat.name AS category
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category cat
    ON fc.category_id = cat.category_id
WHERE f.length > 120
ORDER BY f.length DESC;



-- Task 3
-- Customers with more than 20 rentals

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(r.rental_id) > 20
ORDER BY rental_count DESC;



-- Task 4
-- Number of films per category with at least 50 films

SELECT
    cat.name AS category,
    COUNT(f.film_id) AS film_count
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category cat
    ON fc.category_id = cat.category_id
GROUP BY
    cat.name
HAVING COUNT(f.film_id) >= 50
ORDER BY film_count DESC;