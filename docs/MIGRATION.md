# Migration log

Target: Java 25, Spring Boot 4, PostgreSQL (latest).
Path: 2.5 → 2.7 / Java 17 → 3.x / Java 21 → PostgreSQL → 4.x / Java 25.

Each step lives on its own branch (`migration/stepN-*`) and is done only when:

1. `mvn -B -ntp install` passes (build + tests),
2. `./scripts/smoke.sh` passes (app starts on H2, key public/private endpoints respond, admin JWT login works).

## Step 0 — baseline (`migration/step0-baseline`)

- Spring Boot 2.5.12, Java 11 (`maven.compiler.source/target=11`).
- Build: OK (also builds on JDK 21 with target 11).
- Tests: sm-core 28 run / 0 failures / 13 skipped; sm-shop 33 run / 0 failures / 8 skipped.
  Skipped tests are `@Ignore`d in sources (17 files), they were skipped before the migration.
- Smoke: OK.
- Notes:
  - `sm-shop/src/main/resources/database.properties` is gitignored; the default Spring profile needs it.
    The smoke script supplies the H2 config from `profiles/docker/database.properties` via `loader.path`.

## Step 1 — Spring Boot 2.7.18 + Java 17 (`migration/step1-boot27-java17`)

- Spring Boot 2.7.18, Java 17 (built and tested on JDK 17).
- Tests: sm-core 21 run / 0 failures / 6 skipped; sm-shop 31 run / 0 failures / 6 skipped
  (same 15 + 25 executed tests as baseline; see DECISIONS D-05).
- Smoke: OK (extended: admin + customer JWT flows, negative auth, OpenAPI).
- Changes:
  - H2 2.x: removed `mv_store=false` from JDBC URLs.
  - `spring.main.allow-circular-references=true` (tech debt, D-10).
  - springfox → springdoc-openapi 1.8.0 (OpenRewrite `SpringFoxToSpringDoc` + manual `DocumentationConfiguration`).
  - Spring Security: `WebSecurityConfigurerAdapter` → `SecurityFilterChain` beans (D-14).
  - JUnit 4 → JUnit 5 (OpenRewrite `JUnit4to5Migration`), vintage engine removed.
  - Fixed duplicated path variable in `ProductImageApi` (D-13).

## Step 2 — Spring Boot 3.5.16 + Java 21 (`migration/step2-boot35-java21`)

- Spring Boot 3.5.16 (Spring Framework 6.2, Security 6.5, Hibernate 6.6), Java 21 (built and tested on JDK 21).
- Tests: sm-core 21 run / 0 failures / 6 skipped; sm-shop 31 run / 0 failures / 6 skipped (same as step 1).
- Smoke: OK.
- OpenRewrite: `UpgradeSpringBoot_3_5`, `UpgradeToJava21`, `MigrateToHibernate66` (rewrite-spring 6.37.1);
  poms done by hand (D-20).
- Main manual changes: Ehcache 3/JCache (D-21), text columns (D-22), Hibernate 6.6 mappings & JPQL (D-23),
  id=0 merge listener (D-24), validation kept off (D-26), trailing slash filter (D-27),
  third party leftovers (D-28: shopizer starters, Infinispan + Caffeine 2, jjwt + jaxb-api).

## Step 3 — PostgreSQL 18 (`migration/step3-postgresql`)

- New spring profile `postgresql` (env based configuration), Flyway (`V1__baseline.sql`) + Hibernate `validate`.
- Tests on H2 (default `mvn install`): sm-core 21 / 0 failures / 6 skipped; sm-shop 31 / 0 failures / 6 skipped.
- **Tests on PostgreSQL 18.6** (`scripts/test-postgres.sh`): same numbers, all green.
- Smoke: OK on H2 and on PostgreSQL 18 (fresh DB and restart on a populated DB).
- See `docs/POSTGRESQL.md` (running, data migration from MySQL) and DECISIONS D-31..D-36.

## Step 4 — Spring Boot 4.0.9 + Java 25 (`migration/step4-boot4-java25`)

- Spring Boot 4.0.9 (Spring Framework 7.0, Security 7, Hibernate 7.1, Jackson 3, springdoc 3), Java 25 (JDK 25.0.4).
- Tests on H2: sm-core 23 / 0 failures / 6 skipped (+2 new CMS store tests); sm-shop 31 / 0 failures / 6 skipped.
- Tests on PostgreSQL 18: same numbers, all green.
- Smoke: OK on H2 and PostgreSQL.
- REST API JSON compared with step 3 on 17 endpoints: identical (D-42).
- See DECISIONS D-40..D-45 (Infinispan removed, CMS on file system, Jackson 3, Spring 7 pitfalls, why not 4.1 yet).
