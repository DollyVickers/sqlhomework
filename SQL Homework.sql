USE sakila;

SELECT * FROM actor;

#Show actors' first and last names in table 
SELECT first_name, last name FROM actor;

#Show actors' names in one column
SELECT CONCAT ('first_name',"",'last name') AS actor_Name FROM actor;

#Find ID numbers of all first named Joe
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name="Joe";

#All last names with GEN in their last name
SELECT * FROM actor
WHERE last_name LIKE "%GEN%"

#Order rows by first & last names containing letters L I
SELECT * FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;


#Show country ID's and country column for Afghanistan, Bangladesh & China
SELECT country_id, country FROM country
WHERE country IN("Afghanistan","Bangladesh","China");

#Change Description table
ALTER TABLE actor
ADD description BLOB;
SELECT * FROM actor

#Now delete description column
ALTER TABLE actor
DROP COLUMN description;
SELECT * FROM actor;

#Names of actors and total count of same last name
SELECT COUNT(*) as count, last_name
FROM actor
GROUP BY last_name
#Duplicate last names greater than 2
Select last_name from actor
GROUP BY last_name
HAVING COUNT(*) >2

#Find Groucho Williams by last name Williams
SELECT * FROM actor
WHERE last_name LIKE "WILLIAMS"

#Change Groucho's name to Harpo
SELECT * FROM actor
WHERE actor_id=172;
UPDATE actor
SET first_name = "Harpo"
WHERE actor_id=172;

#Reverse name change
UPDATE actor
SET first_name = "Groucho"
WHERE actor_id = 172;

#Query to recreate schema table address
SHOW CREATE TABLE table_address;
CREATE TABLE 'address' (
	'address_id' smallint(5) unsigned NOT NULL AUTO_INCREMENT,
    'address' varchar(50) NOT NULL,
    'address2' varchar(50) DEFAULT NULL,
    'district' varchar(20) NOT NULL,
    'city_id' smallint(5) unsigned NOT NULL,
    'postal_code' varchar(10) DEFAULT NULL,
    'phone' varchar(20) NOT NULL,
    'location' geometry NOT NULL,
    'last_update' timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY ('address_id'),
	KEY 'idx_fk_city_id' ('city_id'),
	SPATIAL KEY 'idx_location' ('location')
	CONSTRAINT 'fk_address_city' 
	FOREIGN KEY ('city_id') 
	REFERENCES 'city' ('city id') ON UPDATE CASCADE
)ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET= utf8

#Join to show staff naes and their addresses
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
ON staff.address_id = address.address_id;

#Total amount rung up by staff members
	SELECT SUM(amount)
    FROM payment
    WHERE staff_id=2;
    
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(amount)
FROM staff
INNER JOIN payment
ON staff.staff_id=payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;

#Using INNER JOIN list each film and its total number of actors each
SELECT film.film_id, film.title, COUNT(actor_id)
FROM film
INNER JOIN film_actor
ON film.film_id=film_actor.film_id
GROUP BY film_id;

#Number of Hunchback Impossible copies exist in inventory
SELECT film.film_id, film.title, COUNT(store_id)
FROM film
INNER JOIN inventory
ON film.film_id=inventory.film_id
WHERE title="Hunchback Impossible";

#Total paid by customer in alphabetical order
SELECT customer.first_name, customer.last_name, SUM(amount)
FROM customer
INNER JOIN payment
ON customer.customer_id=payment.customer_id
GROUP BY last_name
ORDER BY last_name ASC;

#Using subqueries to find movie titles starting with K and Q
SELECT * FROM sakila.film_text;
SELECT title, title
FROM film_text
WHERE title IN
(SELECT title
FROM film_text
WHERE title = 1
AND title LIKE "K%"
OR title LIKE "Q%");

#Using subqueries to find all actors in film Alone Trip
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
    FROM film_actor
    WHERE film_id =
		(SELECT film_id
        FROM film
        WHERE title="Alone Trip"));
        
#Using retrieve for customer names & email addresses
SELECT customer.first_name, customer.last_name, customer.email
FROM city
INNER JOIN address
ON city.city_id=address.city_id
INNER JOIN customer
ON address.address_id=customer.address_id
WHERE country_id=20;

#Identify all family movies
SELECT film.title, category.name
FROM film
INNER JOIN film_category
ON film.film_id
INNER JOIN category
ON category.category_id
WHERE category.name="Family";

#Most frequently rented movies in descending order
SELECT film.title, count(rental.rental_id)
FROM rental
INNER JOIN inventory
ON rental.inventory_id=inventory.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
GROUP BY film.title
ORDER BY count(rental.rental_id) DESC;

#Total number of dollars in business per store
SELECT staff.store_id, SUM(payment.amount)
FROM staff
INNER JOIN payment
ON staff.staff_id=payment.staff_id
GROUP BY staff.store_id;

#Show store names, id's, city and country
SELECT store.store_id, city.city, country.country
FROM country
INNER JOIN city
ON city.country_id=country.country_id
INNER JOIN address
ON address.city_id=city.city_id
INNER JOIN store
ON store.address_id=address.address_id
GROUP BY city.city;

#Top five genres in gross revenue - descending order
SELECT count(payment.rental_id), category.name, sum(payment.amount)
FROM category 
INNER JOIN film_category
ON category.category_id=film_category.category_id
INNER JOIN inventory
ON film_category.film_id=inventory.film_id
INNER JOIN rental
ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY payment.amount DESC
LIMIT 5;

#View top 5 genres by gross revenue
CREATE VIEW Gross_Revenue AS
SELECT count(payment.rental_id), category.name, sum(payment.amount)
FROM category
INNER JOIN film_category
ON category.category_id=film_category.category_id
INNER JOIN inventory
ON film_category.film_id=inventory.film_id
INNER JOIN rental
ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY payment.amount DESC
LIMIT 5;

#Display the view created
SELECT * FROM gross_revenue;

#Delete view
DROP VIEW gross_revenue;






























