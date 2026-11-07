-- VERIFICACIÓN BÁSICA DEL IMPORT DE SAKILA
SELECT 'actor' AS tabla, COUNT(*) AS registros FROM actor
UNION ALL SELECT 'film', COUNT(*) FROM film
UNION ALL SELECT 'category', COUNT(*) FROM category
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'rental', COUNT(*) FROM rental
UNION ALL SELECT 'payment', COUNT(*) FROM payment
ORDER BY tabla;

-- Comprobar que la vista creada en el ejercicio 48 responde:
-- SELECT * FROM actor_num_peliculas LIMIT 10;

-- Comprobar tablas temporales solo en la conexión donde se crearon:
-- SELECT * FROM cliente_rentas_temporal LIMIT 10;
-- SELECT * FROM peliculas_alquiladas LIMIT 10;
