-- PROYECTO SQL SAKILA / PostgreSQL
-- Ejecutar después de importar BBDD_Proyecto_shakila_sinuser.sql.
-- En DBeaver: seleccionar una sentencia y ejecutar con Ctrl+Enter.
-- Las sentencias de tablas temporales requieren la misma sesión/conexión.

-- EJERCICIO 53: Películas de Tammy Sanders no devueltas
SELECT DISTINCT f.title FROM customer c JOIN rental r ON r.customer_id = c.customer_id JOIN inventory i ON i.inventory_id = r.inventory_id JOIN film f ON f.film_id = i.film_id WHERE c.first_name = 'TAMMY' AND c.last_name = 'SANDERS' AND r.return_date IS NULL ORDER BY f.title;

-- EJERCICIO 54: Actores con películas de Sci-Fi
SELECT DISTINCT a.actor_id, a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN film_category fc ON fc.film_id = fa.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Sci-Fi' ORDER BY a.last_name, a.first_name;

-- EJERCICIO 55: Actores de películas alquiladas después del primer alquiler de Spartacus Cheaper
-- Se compara cada alquiler con la fecha de primer alquiler de SPARTACUS CHEAPER.
WITH primer_alquiler AS (SELECT MIN(r.rental_date) AS fecha FROM rental r JOIN inventory i ON i.inventory_id = r.inventory_id JOIN film f ON f.film_id = i.film_id WHERE f.title = 'SPARTACUS CHEAPER') SELECT DISTINCT a.actor_id, a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN inventory i ON i.film_id = fa.film_id JOIN rental r ON r.inventory_id = i.inventory_id CROSS JOIN primer_alquiler pa WHERE r.rental_date > pa.fecha ORDER BY a.last_name, a.first_name;

-- EJERCICIO 56: Actores que nunca han hecho películas Music
SELECT a.actor_id, a.first_name, a.last_name FROM actor a WHERE NOT EXISTS (SELECT 1 FROM film_actor fa JOIN film_category fc ON fc.film_id = fa.film_id JOIN category c ON c.category_id = fc.category_id WHERE fa.actor_id = a.actor_id AND c.name = 'Music') ORDER BY a.last_name, a.first_name;

-- EJERCICIO 57: Películas alquiladas durante más de ocho días
SELECT DISTINCT f.title FROM film f JOIN inventory i ON i.film_id = f.film_id JOIN rental r ON r.inventory_id = i.inventory_id WHERE r.return_date IS NOT NULL AND r.return_date > r.rental_date + INTERVAL '8 days' ORDER BY f.title;

-- EJERCICIO 58: Películas de la categoría Animation
-- Interpretación: películas clasificadas como Animation.
SELECT DISTINCT f.title FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Animation' ORDER BY f.title;

-- EJERCICIO 59: Películas tan largas como Dancing Fever
SELECT title, length FROM film WHERE length IN (SELECT length FROM film WHERE title = 'DANCING FEVER') ORDER BY title;

-- EJERCICIO 60: Clientes con al menos 7 películas distintas alquiladas
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas FROM customer c JOIN rental r ON r.customer_id = c.customer_id JOIN inventory i ON i.inventory_id = r.inventory_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT i.film_id) >= 7 ORDER BY c.last_name, c.first_name;

-- EJERCICIO 61: Alquileres totales por categoría
SELECT c.name AS categoria, COUNT(r.rental_id) AS cantidad_alquileres FROM category c LEFT JOIN film_category fc ON fc.category_id = c.category_id LEFT JOIN inventory i ON i.film_id = fc.film_id LEFT JOIN rental r ON r.inventory_id = i.inventory_id GROUP BY c.category_id, c.name ORDER BY cantidad_alquileres DESC, categoria;

-- EJERCICIO 62: Películas estrenadas en 2006 por categoría
SELECT c.name AS categoria, COUNT(f.film_id) AS peliculas_2006 FROM category c LEFT JOIN film_category fc ON fc.category_id = c.category_id LEFT JOIN film f ON f.film_id = fc.film_id AND f.release_year = 2006 GROUP BY c.category_id, c.name ORDER BY peliculas_2006 DESC, categoria;

-- EJERCICIO 63: Combinaciones de empleados y tiendas
SELECT s.staff_id, CONCAT_WS(' ', s.first_name, s.last_name) AS empleado, t.store_id FROM staff s CROSS JOIN store t ORDER BY s.staff_id, t.store_id;

-- EJERCICIO 64: Películas alquiladas por cliente
-- Equivale a contar alquileres, incluidos alquileres repetidos de una misma película.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_peliculas_alquiladas FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY total_peliculas_alquiladas DESC, c.customer_id;

