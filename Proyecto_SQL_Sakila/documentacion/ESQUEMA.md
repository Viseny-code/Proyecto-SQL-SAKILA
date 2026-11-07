# Esquema de la base de datos Sakila

La base original crea 15 tablas principales. El diagrama siguiente resume sus principales relaciones (FK). Para una representación visual en DBeaver: seleccionar esquema `public` → **ER Diagram**.

```mermaid
erDiagram
  actor ||--o{ film_actor : actua
  film ||--o{ film_actor : tiene
  film ||--o{ film_category : pertenece
  category ||--o{ film_category : clasifica
  language ||--o{ film : idioma
  film ||--o{ inventory : copias
  store ||--o{ inventory : almacena
  inventory ||--o{ rental : alquilada
  customer ||--o{ rental : realiza
  rental ||--o{ payment : genera
  customer ||--o{ payment : paga
  staff ||--o{ rental : tramita
  staff ||--o{ payment : cobra
  store ||--o{ customer : atiende
  store ||--o{ staff : emplea
  address ||--o{ store : ubicacion
  address ||--o{ staff : domicilio
  address ||--o{ customer : domicilio
  city ||--o{ address : contiene
  country ||--o{ city : contiene
```

**Nota:** el esquema original también contiene una relación de dirección `store.manager_staff_id → staff.staff_id`, circular respecto a `staff.store_id → store.store_id`, y `film.original_language_id → language.language_id`. La cardinalidad del dibujo es un resumen didáctico, no sustituye al diagrama generado desde PostgreSQL.

La estructura SQL original no se ha modificado y está en `base_de_datos/`. Incluye claves primarias y foráneas, índices, funciones y triggers propios de la versión facilitada.
