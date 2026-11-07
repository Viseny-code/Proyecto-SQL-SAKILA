-- PROYECTO SQL SAKILA / PostgreSQL
-- Ejecutar después de importar BBDD_Proyecto_shakila_sinuser.sql.
-- En DBeaver: seleccionar una sentencia y ejecutar con Ctrl+Enter.
-- Las sentencias de tablas temporales requieren la misma sesión/conexión.

-- EJERCICIO 01: Crear esquema de la BBDD
-- El esquema y los datos originales se incluyen en base_de_datos/BBDD_Proyecto_shakila_sinuser.sql.
-- El diagrama entidad-relación se incluye en documentacion/ESQUEMA.md.
-- Para inspeccionar las tablas:
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY table_name;

-- EJERCICIO 02: Películas clasificadas R
SELECT title, rating FROM film WHERE rating = 'R' ORDER BY title;

-- EJERCICIO 03: Actores con ID entre 30 y 40
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id BETWEEN 30 AND 40 ORDER BY actor_id;

-- EJERCICIO 04: Películas cuyo idioma coincide con el original
-- Nota: si original_language_id es NULL, no se considera igualdad.
SELECT film_id, title, language_id, original_language_id FROM film WHERE language_id = original_language_id;

-- EJERCICIO 05: Películas por duración ascendente
SELECT title, length FROM film ORDER BY length ASC NULLS LAST, title;

-- EJERCICIO 06: Actores con Allen en el apellido
SELECT first_name, last_name FROM actor WHERE last_name ILIKE '%Allen%' ORDER BY last_name, first_name;

-- EJERCICIO 07: Recuento por clasificación
SELECT rating, COUNT(*) AS total_peliculas FROM film GROUP BY rating ORDER BY rating;

-- EJERCICIO 08: PG-13 o más de 3 horas
SELECT title, rating, length FROM film WHERE rating = 'PG-13' OR length > 180 ORDER BY title;

-- EJERCICIO 09: Variabilidad del coste de reemplazo
-- Interpretación: rango, varianza muestral y desviación estándar de replacement_cost.
SELECT ROUND(AVG(replacement_cost), 2) AS promedio, MIN(replacement_cost) AS minimo, MAX(replacement_cost) AS maximo, ROUND(MAX(replacement_cost) - MIN(replacement_cost), 2) AS rango, ROUND(VAR_SAMP(replacement_cost), 2) AS varianza_muestral, ROUND(STDDEV_SAMP(replacement_cost), 2) AS desviacion_estandar_muestral FROM film;

-- EJERCICIO 10: Duración mínima y máxima
SELECT MIN(length) AS duracion_minima, MAX(length) AS duracion_maxima FROM film;

-- EJERCICIO 11: Coste del antepenúltimo alquiler por fecha
-- Interpretación: antepenúltimo ALQUILER según rental_date; coste = SUM de pagos asociados.
SELECT r.rental_id, r.rental_date, p.amount AS coste_pagado FROM rental r LEFT JOIN LATERAL (SELECT SUM(amount) AS amount FROM payment WHERE rental_id = r.rental_id) p ON TRUE ORDER BY r.rental_date DESC, r.rental_id DESC OFFSET 2 LIMIT 1;

-- EJERCICIO 12: Películas distintas de NC-17 y G
SELECT title, rating FROM film WHERE rating NOT IN ('NC-17', 'G') ORDER BY title;

-- EJERCICIO 13: Media de duración por clasificación
SELECT rating, ROUND(AVG(length), 2) AS duracion_media_minutos FROM film GROUP BY rating ORDER BY rating;

-- EJERCICIO 14: Películas que superan 180 minutos
SELECT title, length FROM film WHERE length > 180 ORDER BY length DESC, title;

-- EJERCICIO 15: Ingresos totales
SELECT COALESCE(SUM(amount), 0) AS ingresos_totales FROM payment;

-- EJERCICIO 16: Diez clientes con ID más alto
SELECT customer_id, first_name, last_name FROM customer ORDER BY customer_id DESC LIMIT 10;

-- EJERCICIO 17: Actores de Egg Igby
SELECT DISTINCT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN film f ON f.film_id = fa.film_id WHERE f.title = 'EGG IGBY' ORDER BY a.last_name, a.first_name;

-- EJERCICIO 18: Títulos únicos
SELECT DISTINCT title FROM film ORDER BY title;

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

