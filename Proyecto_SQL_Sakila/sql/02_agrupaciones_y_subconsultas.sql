-- PROYECTO SQL SAKILA / PostgreSQL
-- Ejecutar después de importar BBDD_Proyecto_shakila_sinuser.sql.
-- En DBeaver: seleccionar una sentencia y ejecutar con Ctrl+Enter.
-- Las sentencias de tablas temporales requieren la misma sesión/conexión.

-- EJERCICIO 19: Comedias de más de 180 minutos
SELECT f.title, f.length FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Comedy' AND f.length > 180 ORDER BY f.title;

-- EJERCICIO 20: Categorías con media superior a 110 minutos
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media FROM category c JOIN film_category fc ON fc.category_id = c.category_id JOIN film f ON f.film_id = fc.film_id GROUP BY c.category_id, c.name HAVING AVG(f.length) > 110 ORDER BY duracion_media DESC;

-- EJERCICIO 21: Media de duración real de los alquileres
-- Interpretación: duración REAL en días de los alquileres devueltos, no rental_duration de film.
SELECT ROUND(AVG(EXTRACT(EPOCH FROM (return_date - rental_date)) / 86400)::numeric, 2) AS dias_medios_de_alquiler FROM rental WHERE return_date IS NOT NULL;

-- EJERCICIO 22: Nombre completo de actores
SELECT actor_id, CONCAT_WS(' ', first_name, last_name) AS nombre_completo FROM actor ORDER BY last_name, first_name;

-- EJERCICIO 23: Alquileres por día ordenados por frecuencia
SELECT rental_date::date AS dia, COUNT(*) AS total_alquileres FROM rental GROUP BY rental_date::date ORDER BY total_alquileres DESC, dia;

-- EJERCICIO 24: Películas de duración superior a la media
SELECT title, length FROM film WHERE length > (SELECT AVG(length) FROM film) ORDER BY length DESC, title;

-- EJERCICIO 25: Número de alquileres por mes
SELECT DATE_TRUNC('month', rental_date)::date AS mes, COUNT(*) AS total_alquileres FROM rental GROUP BY DATE_TRUNC('month', rental_date)::date ORDER BY mes;

-- EJERCICIO 26: Promedio, desviación y varianza del pago
SELECT ROUND(AVG(amount), 2) AS pago_medio, ROUND(STDDEV_SAMP(amount), 2) AS desviacion_estandar, ROUND(VAR_SAMP(amount), 2) AS varianza FROM payment;

-- EJERCICIO 27: Películas con precio de alquiler superior a la media
SELECT title, rental_rate FROM film WHERE rental_rate > (SELECT AVG(rental_rate) FROM film) ORDER BY rental_rate DESC, title;

-- EJERCICIO 28: Actores que participaron en más de 40 películas
SELECT actor_id, COUNT(DISTINCT film_id) AS total_peliculas FROM film_actor GROUP BY actor_id HAVING COUNT(DISTINCT film_id) > 40 ORDER BY total_peliculas DESC, actor_id;

