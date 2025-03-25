-- SELECT Query: Retrieve All Data

USE mavenmovies;
SELECT * FROM film;

-- Find all films released in the year 2005.

SELECT * FROM film
WHERE release_year = 2005;

-- Retrieve the names of films that contain the word 'Action' in their title.

SELECT title FROM film
WHERE title LIKE '%Action%';

-- Get the distinct categories name of films available in the category table.

SELECT DISTINCT name FROM category;

-- List the films ordered by their rental rate in descending order.

SELECT title, rental_rate
FROM film
ORDER BY rental_rate DESC;

-- Retrieve a list of customers and the titles of films they rented (Join customer and rental tables).

SELECT customer.first_name, customer.last_name, film.title
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id;


-- How many films are in each category?

SELECT category_id, COUNT(film_id) AS num_films
FROM film_category
GROUP BY category_id;


-- Find categories with more than 10 films.

SELECT category_id, COUNT(film_id) AS num_films
FROM film_category
GROUP BY category_id
HAVING COUNT(film_id) > 10;


-- List customers who rented the film titled 'BUGSY SONG'. (Use Subquery)

SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON inventory.film_id = film.film_id
    WHERE film.title = 'BUGSY SONG'
);


-- List all employees (staff) and the films they have rented, where the rental 
-- is still not returned
SELECT * FROM staff;
SELECT * FROM inventory;
SELECT * FROM film;
SELECT * FROM rental;
 

SELECT staff.first_name, staff.last_name, film.title
FROM staff
JOIN rental ON staff.staff_id = rental.staff_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL;



-- Update the rental rate of the film titled 'GUMP DATE' to 5.99.

UPDATE film
SET rental_rate = 4.99
WHERE title = 'Avatar';


-- Delete all rentals for the film titled 'The Dark Knight'. (Use Subquery)

DELETE FROM rental
WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    JOIN film ON inventory.film_id = film.film_id
    WHERE film.title = 'The Dark Knight'
);


-- Show the customer’s first name, last name, and a custom message based on whether they have 
-- overdue rentals.

SELECT first_name, last_name,
       CASE 
           WHEN rental.return_date IS NULL THEN 'Overdue'
           ELSE 'Returned'
       END AS rental_status
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id;


-- List all customers and any films 
-- they rented, including those who have not rented any films (use LEFT JOIN).

SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT customer.first_name, customer.last_name, film.title
FROM customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film ON inventory.film_id = film.film_id;


-- List the first names of all customers and employees (combine customer and staff tables).

SELECT first_name FROM customer
UNION
SELECT first_name FROM staff;


-- Find the total number of rentals for each film title

SELECT film.title, COUNT(rental.rental_id) AS total_rentals
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY total_rentals DESC;


-- Calculate the average payment amount by each customer

SELECT customer.first_name, customer.last_name, AVG(payment.amount) AS avg_payment
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY avg_payment DESC;


-- List the number of customers who rented each category of films

SELECT category.name, COUNT(DISTINCT rental.customer_id) AS customer_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY customer_count DESC;


-- Create a combination of all films and all customers using a cross join

SELECT customer.first_name, customer.last_name, film.title
FROM customer
CROSS JOIN film;


-- Retrieve the 2nd most expensive films based on rental rate

SELECT title, rental_rate
FROM film
ORDER BY rental_rate DESC
LIMIT 1,1;
