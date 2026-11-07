-- PROYECTO SQL SAKILA / PostgreSQL
-- Ejecutar después de importar BBDD_Proyecto_shakila_sinuser.sql.
-- En DBeaver: seleccionar una sentencia y ejecutar con Ctrl+Enter.
-- Las sentencias de tablas temporales requieren la misma sesión/conexión.

-- EJERCICIO 48: Crear vista actor_num_peliculas
CREATE OR REPLACE VIEW actor_num_peliculas AS SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS numero_peliculas FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id GROUP BY a.actor_id, a.first_name, a.last_name;

-- Para consultar la vista:
SELECT * FROM actor_num_peliculas ORDER BY numero_peliculas DESC, actor_id;

-- EJERCICIO 49: Total de alquileres de cada cliente
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY c.customer_id;

-- EJERCICIO 50: Duración total de películas de Action
SELECT c.name AS categoria, COALESCE(SUM(f.length), 0) AS minutos_totales FROM category c JOIN film_category fc ON fc.category_id = c.category_id JOIN film f ON f.film_id = fc.film_id WHERE c.name = 'Action' GROUP BY c.name;

-- EJERCICIO 51: Tabla temporal cliente_rentas_temporal
-- TEMP: la tabla solo existe en la sesión de conexión actual.
DROP TABLE IF EXISTS pg_temp.cliente_rentas_temporal;
CREATE TEMP TABLE cliente_rentas_temporal AS SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name;
SELECT * FROM cliente_rentas_temporal ORDER BY total_alquileres DESC, customer_id;

-- EJERCICIO 52: Tabla temporal peliculas_alquiladas (10 o más)
-- TEMP: la tabla solo existe en la sesión de conexión actual.
DROP TABLE IF EXISTS pg_temp.peliculas_alquiladas;
CREATE TEMP TABLE peliculas_alquiladas AS SELECT f.film_id, f.title, COUNT(r.rental_id) AS veces_alquilada FROM film f JOIN inventory i ON i.film_id = f.film_id JOIN rental r ON r.inventory_id = i.inventory_id GROUP BY f.film_id, f.title HAVING COUNT(r.rental_id) >= 10;
SELECT * FROM peliculas_alquiladas ORDER BY veces_alquilada DESC, title;

