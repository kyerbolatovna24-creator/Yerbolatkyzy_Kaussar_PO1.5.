SELECT * 
FROM public.film
LIMIT 5;

-- Insert new film
INSERT INTO public.film (
    title,
    language_id,
    rental_duration,
    rental_rate,
    replacement_cost,
    rating
)
VALUES (
    'The Matrix Reloaded',
    1,
    7,
    4.99,
    19.99,
    'R'
)
RETURNING film_id, title;

-- Verify inserted row
SELECT film_id,
       title,
       rental_rate,
       rating
FROM public.film
WHERE title = 'The Matrix Reloaded';