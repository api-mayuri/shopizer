#!/usr/bin/env bash
# Smoke test: starts the sm-shop jar, checks key endpoints, stops the app.
# Default: H2 (default profile). PostgreSQL: SPRING_PROFILES_ACTIVE=postgresql ./scripts/smoke.sh
# (connection settings: SHOPIZER_DB_URL / SHOPIZER_DB_USER / SHOPIZER_DB_PASSWORD).
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAR="$(ls "$ROOT"/sm-shop/target/shopizer.jar "$ROOT"/sm-shop/target/sm-shop-*.jar 2>/dev/null | grep -v original | head -1)"
PORT="${PORT:-8080}"
WORK="$(mktemp -d)"
LOG="$WORK/app.log"
[ -n "$JAR" ] || { echo "jar not found, run mvn install first"; exit 2; }

# database.properties is gitignored: use the H2 config from the docker profile, outside the jar
mkdir -p "$WORK/conf"
cp "$ROOT/sm-shop/src/main/resources/profiles/docker/database.properties" "$WORK/conf/"
LAUNCHER=org.springframework.boot.loader.launch.PropertiesLauncher
unzip -l "$JAR" | grep -q 'org/springframework/boot/loader/launch/PropertiesLauncher' && LAUNCHER=org.springframework.boot.loader.launch.PropertiesLauncher
cd "$WORK"
java -Dloader.path="$WORK/conf" -cp "$JAR" $LAUNCHER --server.port="$PORT" > "$LOG" 2>&1 &
PID=$!
trap 'kill $PID 2>/dev/null; wait $PID 2>/dev/null' EXIT

for i in $(seq 1 180); do
  curl -sf "http://localhost:$PORT/actuator/health" >/dev/null 2>&1 && break
  kill -0 $PID 2>/dev/null || { echo "app died"; tail -80 "$LOG"; exit 1; }
  sleep 1
done

FAIL=0
EMAIL="smoke-$(date +%s)-$RANDOM@test.com"
check() { # path expected_code
  code=$(curl -s -o "$WORK/body" -w '%{http_code}' "http://localhost:$PORT$1")
  if [ "$code" = "$2" ]; then echo "OK   $code $1"; else echo "FAIL $code $1 (expected $2)"; head -c 300 "$WORK/body"; echo; FAIL=1; fi
}
check /actuator/health 200
check /api/v1/store/DEFAULT 200
check "/api/v1/category?lang=en" 200
check "/api/v1/products?lang=en" 200
check /api/v1/country 200
check /api/v1/country/ 200
check /api/v1/zones?code=CA 200
check /api/v1/private/stores 401
check /v3/api-docs 200
# admin login (JWT) and an authenticated call
TOKEN=$(curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"username":"admin@shopizer.com","password":"password"}' \
  "http://localhost:$PORT/api/v1/private/login" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
if [ -n "$TOKEN" ]; then
  echo "OK   login admin@shopizer.com"
  code=$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $TOKEN" "http://localhost:$PORT/api/v1/private/stores")
  [ "$code" = 200 ] && echo "OK   $code /api/v1/private/stores (auth)" || { echo "FAIL $code /api/v1/private/stores (auth)"; FAIL=1; }
else
  echo "FAIL login admin@shopizer.com"; FAIL=1
fi
# wrong password must be rejected
code=$(curl -s -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' \
  -d '{"username":"admin@shopizer.com","password":"wrong"}' "http://localhost:$PORT/api/v1/private/login")
[ "$code" = 401 ] && echo "OK   $code login with wrong password" || { echo "FAIL $code login with wrong password (expected 401)"; FAIL=1; }

# customer: register, login (JWT), authenticated profile call
code=$(curl -s -o "$WORK/body" -w '%{http_code}' -X POST -H 'Content-Type: application/json' \
  -d '{"emailAddress":"'"$EMAIL"'","password":"Smoke123!","gender":"M","language":"en","storeCode":"DEFAULT","billing":{"firstName":"Smoke","lastName":"Test","country":"CA"}}' \
  "http://localhost:$PORT/api/v1/customer/register")
[ "$code" = 200 ] && echo "OK   $code customer register" || { echo "FAIL $code customer register"; head -c 300 "$WORK/body"; echo; FAIL=1; }
CTOKEN=$(curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"username":"'"$EMAIL"'","password":"Smoke123!"}' \
  "http://localhost:$PORT/api/v1/customer/login" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
if [ -n "$CTOKEN" ]; then
  echo "OK   customer login"
  code=$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $CTOKEN" "http://localhost:$PORT/api/v1/auth/customer/profile")
  [ "$code" = 200 ] && echo "OK   $code /api/v1/auth/customer/profile (auth)" || { echo "FAIL $code /api/v1/auth/customer/profile (auth)"; FAIL=1; }
else
  echo "FAIL customer login"; FAIL=1
fi
code=$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/api/v1/auth/customer/profile")
[ "$code" = 401 ] && echo "OK   $code /api/v1/auth/customer/profile (anonymous)" || { echo "FAIL $code /api/v1/auth/customer/profile (anonymous, expected 401)"; FAIL=1; }

[ $FAIL = 0 ] && echo "SMOKE PASSED" || { echo "SMOKE FAILED"; tail -40 "$LOG"; }
exit $FAIL
