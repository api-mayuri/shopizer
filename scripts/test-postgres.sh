#!/usr/bin/env bash
# Runs the whole test suite against a real PostgreSQL (spring profile "postgresql").
#
# Uses a PostgreSQL started with Docker (image postgres:18 by default), or an existing server:
#   PG_HOST/PG_PORT/PG_USER/PG_PASSWORD  (default: localhost:55432 shopizer/password, container shopizer-test-pg)
# Each module gets a fresh database (shopizer_test_core, shopizer_test_shop). Extra args go to Maven.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PG_IMAGE="${PG_IMAGE:-postgres:18}"
PG_HOST="${PG_HOST:-localhost}"
PG_PORT="${PG_PORT:-55432}"
PG_USER="${PG_USER:-shopizer}"
PG_PASSWORD="${PG_PASSWORD:-password}"
CONTAINER="${PG_CONTAINER:-shopizer-test-pg}"

if [ -z "${PG_EXTERNAL:-}" ]; then
  if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
    docker run -d --name "$CONTAINER" -e POSTGRES_USER="$PG_USER" -e POSTGRES_PASSWORD="$PG_PASSWORD" \
      -e POSTGRES_DB=postgres -p "$PG_PORT":5432 "$PG_IMAGE" >/dev/null
  fi
  for i in $(seq 1 60); do docker exec "$CONTAINER" pg_isready -U "$PG_USER" >/dev/null 2>&1 && break; sleep 1; done
  psql_() { docker exec -i "$CONTAINER" psql -v ON_ERROR_STOP=1 -U "$PG_USER" -d postgres -q "$@"; }
else
  psql_() { PGPASSWORD="$PG_PASSWORD" psql -v ON_ERROR_STOP=1 -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d postgres -q "$@"; }
fi

run_module() { # module database
  psql_ -c "DROP DATABASE IF EXISTS $2" -c "CREATE DATABASE $2"
  echo "== $1 on PostgreSQL ($2)"
  SPRING_PROFILES_ACTIVE=postgresql \
  SHOPIZER_DB_URL="jdbc:postgresql://$PG_HOST:$PG_PORT/$2" SHOPIZER_DB_USER="$PG_USER" SHOPIZER_DB_PASSWORD="$PG_PASSWORD" \
    mvn -B -ntp -f "$ROOT/pom.xml" -pl "$1" test "${@:3}"
}

mvn -B -ntp -q -f "$ROOT/pom.xml" install -DskipTests
run_module sm-core shopizer_test_core "$@"
run_module sm-shop shopizer_test_shop "$@"
echo "PostgreSQL test run passed"
