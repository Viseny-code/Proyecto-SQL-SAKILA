-- PROYECTO SQL SAKILA / PostgreSQL
-- Ejecutar después de importar BBDD_Proyecto_shakila_sinuser.sql.
-- En DBeaver: seleccionar una sentencia y ejecutar con Ctrl+Enter.
-- Las sentencias de tablas temporales requieren la misma sesión/conexión.

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

