# PostgreSQL

Целевая БД — **PostgreSQL 18** (последний стабильный релиз; 19 на момент миграции был только RC1).
Профиль Spring: `postgresql`.

## Запуск

```bash
# PostgreSQL + Shopizer в Docker
mvn clean install -DskipTests
docker compose up --build

# или локально, с уже запущенным PostgreSQL
SPRING_PROFILES_ACTIVE=postgresql \
SHOPIZER_DB_URL=jdbc:postgresql://localhost:5432/SALESMANAGER \
SHOPIZER_DB_USER=shopizer SHOPIZER_DB_PASSWORD=password \
java -jar sm-shop/target/shopizer.jar
```

| Переменная | По умолчанию | |
|---|---|---|
| `SHOPIZER_DB_URL` | `jdbc:postgresql://localhost:5432/SALESMANAGER` | JDBC URL |
| `SHOPIZER_DB_USER` / `SHOPIZER_DB_PASSWORD` | `shopizer` / `password` | |
| `SHOPIZER_DB_POOL_SIZE` | `10` | размер пула Hikari |
| `SHOPIZER_JWT_SECRET` | пусто (случайный ключ) | ключ JWT, Base64, ≥ 64 байт: `openssl rand -base64 64` |
| `SHOPIZER_DDL_AUTO` | `validate` | режим Hibernate. Не менять: схемой управляет Flyway |

Настройки лежат в `sm-core/src/main/resources/profiles/postgresql/database.properties` и
`sm-core/src/main/resources/application-postgresql.properties` (Flyway).

## Схема

- Схемой управляет **Flyway**: `sm-core/src/main/resources/db/migration/postgresql`.
  Схема `salesmanager` создаётся Flyway. Hibernate только проверяет маппинг (`hbm2ddl=validate`).
- `V1__baseline.sql` сгенерирован из маппинга Hibernate 6 на PostgreSQL 18. Из него убраны `CHECK`-ограничения
  для enum-колонок, чтобы новое значение enum не требовало миграции.
- **Любое изменение сущностей = новая миграция** `V2__...sql`. Иначе приложение не стартует: валидация Hibernate это поймает.
- Справочные данные (страны, языки, валюты, магазин DEFAULT, администратор) приложение, как и раньше, создаёт при первом старте.

## Тесты на PostgreSQL

```bash
./scripts/test-postgres.sh        # поднимает postgres:18 в Docker (порт 55432), гоняет sm-core и sm-shop
SPRING_PROFILES_ACTIVE=postgresql ./scripts/smoke.sh
```

Обычный `mvn install` по-прежнему идёт на H2 (быстро, без Docker). В CI есть оба варианта.

## Перенос данных из существующей MySQL

1. Поднять пустую БД и применить схему: один раз запустить приложение с профилем `postgresql` на пустой базе
   (Flyway создаст схему) и остановить. Либо выполнить `V1__baseline.sql` руками.
2. Очистить справочные данные, которые приложение создало при старте (или переносить в базу, где схема создана
   через `V1__baseline.sql` без запуска приложения), затем перенести **только данные**, например pgloader:
   ```
   LOAD DATABASE
     FROM mysql://user:pass@mysql-host/SALESMANAGER
     INTO postgresql://shopizer:password@pg-host/SALESMANAGER
   WITH data only, truncate, disable triggers, reset no sequences
   ALTER SCHEMA 'SALESMANAGER' RENAME TO 'salesmanager'
   ;
   ```
3. Пересчитать генераторы id (обязательно, см. DECISIONS D-25 / D-33):
   ```bash
   psql -h pg-host -U shopizer -d SALESMANAGER -f scripts/postgresql/reset-sm-sequencer.sql
   ```
4. Запустить приложение. Flyway увидит существующую схему и, если таблицы истории ещё нет, сделает baseline на версии 1
   (`spring.flyway.baseline-on-migrate=true`).

Перед боевым переносом прогоните его на копии. Особенно проверьте поля `boolean` (в MySQL это `bit`/`tinyint`)
и даты: pgloader преобразует их сам, но проверить стоит.
