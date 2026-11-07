# Guía práctica para DBeaver y PostgreSQL

## 1. Preparar la conexión

Abre DBeaver → **Nueva conexión** → **PostgreSQL**. Indica servidor local (habitualmente `localhost`), puerto habitual `5432`, usuario y contraseña de tu instalación. Pulsa **Probar conexión**. Si todavía no tienes PostgreSQL instalado, DBeaver por sí solo no es un servidor de base de datos.

## 2. Crear base de datos de trabajo

En la conexión, crear una nueva base de datos llamada `sakila_proyecto`. Abrir un editor SQL conectado **a esa base**, no a `postgres` ni a otra base que ya uses. Si tienes que ejecutar `CREATE DATABASE sakila_proyecto;`, hazlo desde otra base, vuelve a conectar y selecciona `sakila_proyecto`.

## 3. Importar el volcado de la actividad

Abre `base_de_datos/BBDD_Proyecto_shakila_sinuser.sql` en un editor de DBeaver y usa **Ejecutar script SQL** (no solo ejecutar sentencia). Como incluye miles de `INSERT`, no pegues cada instrucción manualmente. Conectarse como usuario con suficientes permisos; el fichero usa `ALTER TABLE ... DISABLE TRIGGER ALL`, que puede requerir superusuario.

**Atención a compatibilidad:** es un dump antiguo. Contiene instrucciones como `SET default_with_oids = false;`, eliminada en las versiones modernas de PostgreSQL, y funciones antiguas. Si falla, no sigas como si hubiese cargado correctamente: detén la importación, revisa el mensaje, limpia/recrea la base de prueba e identifica la instrucción incompatible. `SET default_with_oids = false;` se puede comentar en una **copia** del archivo para PostgreSQL moderno. Otros errores deben corregirse según su mensaje concreto. No modifiques el original.

## 4. Verificar importación

Ejecuta `sql/99_verificacion.sql`. Deberías obtener registros en `actor`, `film`, `customer`, `rental`, `payment` y otras tablas. Los recuentos precisos dependen de que haya terminado la importación. Si aparece una tabla vacía o inexistente, revisa primero el paso 3.

## 5. Ejecutar ejercicios

Abre `sql/00_todas_las_consultas.sql`. Sitúa el cursor en una sentencia, pulsa **Ctrl+Enter** y revisa la tabla de resultados. También puedes seleccionar consultas concretas. Para ejecutar todo como script, utiliza el comando de ejecución de script de tu versión de DBeaver y revisa los mensajes. Las consultas 48, 51 y 52 crean objetos; no son `SELECT` de solo lectura. Las tablas temporales 51 y 52 se pierden cuando cambia la sesión de conexión.

## 6. Crear el diagrama visual

En DBeaver, abre la conexión → `Schemas` → `public`; selecciona las tablas y crea un **ER Diagram** (según versión, clic derecho → ER Diagram). Puede exportarse como imagen para adjuntarla al repositorio. El proyecto ya incluye un esquema en `documentacion/ESQUEMA.md`.

## 7. Publicar en GitHub

Crea un repositorio público llamado `Proyecto-Consultas-SQL-Sakila`, sube **el contenido** de la carpeta del proyecto conservando todas las subcarpetas y revisa que los archivos aparezcan antes de enviar al profesor. Si el curso restringe publicar el dataset, confirma el permiso antes de publicar el volcado original.

## 8. Comprobaciones finales

- [ ] Base importada sin errores críticos.
- [ ] `99_verificacion.sql` devuelve datos de todas las tablas principales.
- [ ] Consultas 02–64 ejecutan sin errores; algunos resultados pueden ser vacíos legítimamente.
- [ ] La vista 48 puede consultarse.
- [ ] Las tablas temporales 51 y 52 pueden consultarse en la misma sesión.
- [ ] README y estructura de archivos visibles en GitHub.
- [ ] Enlace al repositorio público comprobado antes de entregar.
