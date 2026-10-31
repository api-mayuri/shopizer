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
