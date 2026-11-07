-- PROYECTO SQL SAKILA / PostgreSQL
-- Ejecutar después de importar BBDD_Proyecto_shakila_sinuser.sql.
-- En DBeaver: seleccionar una sentencia y ejecutar con Ctrl+Enter.
-- Las sentencias de tablas temporales requieren la misma sesión/conexión.

-- EJERCICIO 29: Todas las películas y copias en inventario
-- Se contabilizan copias registradas, NO necesariamente disponibles actualmente.
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS copias_en_inventario FROM film f LEFT JOIN inventory i ON i.film_id = f.film_id GROUP BY f.film_id, f.title ORDER BY f.title;

-- EJERCICIO 30: Actores y número de películas
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS numero_peliculas FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id GROUP BY a.actor_id, a.first_name, a.last_name ORDER BY numero_peliculas DESC, a.actor_id;

-- EJERCICIO 31: Películas con sus actores, incluyendo películas sin reparto
SELECT f.film_id, f.title, a.actor_id, a.first_name, a.last_name FROM film f LEFT JOIN film_actor fa ON fa.film_id = f.film_id LEFT JOIN actor a ON a.actor_id = fa.actor_id ORDER BY f.title, a.last_name NULLS LAST, a.first_name;

-- EJERCICIO 32: Actores con sus películas, incluyendo actores sin películas
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id LEFT JOIN film f ON f.film_id = fa.film_id ORDER BY a.last_name, a.first_name, f.title NULLS LAST;

-- EJERCICIO 33: Todas las películas y todos los alquileres
-- FULL OUTER JOIN conserva filmes sin alquiler y alquileres sin película asociable.
SELECT f.film_id, f.title, r.rental_id, r.rental_date FROM film f FULL OUTER JOIN inventory i ON i.film_id = f.film_id FULL OUTER JOIN rental r ON r.inventory_id = i.inventory_id ORDER BY f.film_id NULLS LAST, r.rental_date NULLS LAST;

-- EJERCICIO 34: Los cinco clientes que más han gastado
SELECT c.customer_id, c.first_name, c.last_name, ROUND(SUM(p.amount), 2) AS gasto_total FROM customer c JOIN payment p ON p.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY gasto_total DESC, c.customer_id LIMIT 5;

-- EJERCICIO 35: Actores con primer nombre Johnny
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'JOHNNY' ORDER BY last_name;

-- EJERCICIO 36: Renombrar columnas de nombre y apellido
SELECT first_name AS "Nombre", last_name AS "Apellido" FROM actor ORDER BY "Apellido", "Nombre";

-- EJERCICIO 37: ID de actor más pequeño y mayor
SELECT MIN(actor_id) AS id_minimo, MAX(actor_id) AS id_maximo FROM actor;

-- EJERCICIO 38: Cantidad total de actores
SELECT COUNT(*) AS total_actores FROM actor;

-- EJERCICIO 39: Actores ordenados por apellido
SELECT actor_id, first_name, last_name FROM actor ORDER BY last_name ASC, first_name ASC;

-- EJERCICIO 40: Primeras cinco películas por ID
SELECT film_id, title FROM film ORDER BY film_id ASC LIMIT 5;

-- EJERCICIO 41: Nombre más repetido entre actores
SELECT first_name, COUNT(*) AS veces FROM actor GROUP BY first_name ORDER BY veces DESC, first_name LIMIT 1;

-- EJERCICIO 42: Alquileres y nombres de clientes
SELECT r.rental_id, r.rental_date, c.customer_id, c.first_name, c.last_name FROM rental r JOIN customer c ON c.customer_id = r.customer_id ORDER BY r.rental_date, r.rental_id;

-- EJERCICIO 43: Todos los clientes, incluidos los que no alquilaron
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id ORDER BY c.customer_id, r.rental_date NULLS LAST;

-- EJERCICIO 44: CROSS JOIN de film y category
-- ¿Aporta valor? No para relacionar categorías REALES: genera todas las combinaciones posibles,
-- incluso las que no corresponden a ninguna película. Útil como ejercicio o matriz de combinaciones.
SELECT f.film_id, f.title, c.category_id, c.name AS categoria FROM film f CROSS JOIN category c ORDER BY f.film_id, c.category_id;

-- EJERCICIO 45: Actores en películas de acción
SELECT DISTINCT a.actor_id, a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN film_category fc ON fc.film_id = fa.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Action' ORDER BY a.last_name, a.first_name;

-- EJERCICIO 46: Actores sin películas
SELECT a.actor_id, a.first_name, a.last_name FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id WHERE fa.actor_id IS NULL ORDER BY a.last_name, a.first_name;

-- EJERCICIO 47: Nombre de actores y cantidad de películas
SELECT CONCAT_WS(' ', a.first_name, a.last_name) AS nombre_actor, COUNT(fa.film_id) AS numero_peliculas FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id GROUP BY a.actor_id, a.first_name, a.last_name ORDER BY numero_peliculas DESC, nombre_actor;

