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
