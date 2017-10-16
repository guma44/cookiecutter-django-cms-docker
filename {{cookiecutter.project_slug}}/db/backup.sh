#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


# we might run into trouble when using the default `postgres` user, e.g. when dropping the postgres
# database in restore.sh. Check that something else is used here
if [ "$DB_USER" == "postgres" ]
then
    echo "creating a backup as the postgres user is not supported, make sure to set the DB_USER environment variable"
    exit 1
fi

# export the postgres password so that subsequent commands don't ask for it
export PGPASSWORD=$DB_PASS

echo "creating DB backup"
echo "------------------"

TIMESTAMP="$(date +'%Y_%m_%dT%H_%M_%S')"

DB_FILENAME=backup_${TIMESTAMP}_db.sql.gz
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME | gzip > /backups/$DB_FILENAME

echo "creating Media backup"
echo "---------------------"

MEDIA_FILENAME=backup_${TIMESTAMP}_media.tar.gz

tar -zcvf /backups/$MEDIA_FILENAME -C /public media

echo "successfully created backups: $DB_FILENAME and $MEDIA_FILENAME"
