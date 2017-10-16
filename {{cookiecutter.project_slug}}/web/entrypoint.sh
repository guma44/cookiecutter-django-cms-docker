#!/usr/bin/env bash

set -o errexit
set -o pipefail

# the official postgres image uses 'postgres' as default user if not set explictly.
if [ -z "$DB_USER" ]; then
    export DB_USER=postgres
fi

export DATABASE_URL=$DB_HOST://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_USER


function postgres_ready(){
python << END
import sys
import psycopg2
try:
    conn = psycopg2.connect(dbname="$DB_NAME", user="$DB_USER", password="$DB_PASS", host="$DB_HOST")
except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

until postgres_ready; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continuing..."

exec "$@"