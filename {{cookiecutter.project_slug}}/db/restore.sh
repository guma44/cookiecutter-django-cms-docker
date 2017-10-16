#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


# we might run into trouble when using the default `postgres` user, e.g. when dropping the postgres
# database in restore.sh. Check that something else is used here
if [ "$DB_USER" == "postgres" ]
then
    echo "restoring as the postgres user is not supported, make sure to set the DB_USER environment variable"
    exit 1
fi

# export the postgres password so that subsequent commands don't ask for it
export PGPASSWORD=$DB_PASS

# check that we have an argument for a filename candidate
if [[ $# -eq 0 ]] ; then
    echo 'usage:'
    echo '    docker-compose -f docker-compose-prod.yml run postgres restore <backup-timestamp>'
    echo ''
    echo 'to get a list of available backups, run:'
    echo '    docker-compose -f docker-compose-prod.yml run postgres list-backups'
    exit 1
fi

# set the backupfile variable
DB_BACKUPFILE=/backups/backup_$1_db.sql.gz
MEDIA_BACKUPFILE=/backups/backup_$1_media.tar.gz

# check that the file exists
if ! [ -f $DB_BACKUPFILE ]; then
    echo "$DB_BACKUPFILE backup file not found"
    echo 'to get a list of available backups, run:'
    echo '    docker-compose -f production.yml run postgres list-backups'
    exit 1
fi

echo "beginning restore from $DB_BACKUPFILE"
echo "-----------------------------------------"

# delete the db
# deleting the db can fail. Spit out a comment if this happens but continue since the db
# is created in the next step
echo "deleting old database $DB_USER"
if dropdb -h $DB_HOST -U $DB_USER $DB_USER
then echo "deleted $DB_USER database"
else echo "database $DB_USER does not exist, continue"
fi

# create a new database
echo "creating new database $DB_USER"
createdb -h $DB_HOST -U $DB_USER $DB_NAME -O $DB_USER

# restore the database
echo "restoring database $DB_USER"
gunzip -c $DB_BACKUPFILE | psql -h $DB_HOST -U $DB_USER

echo "beginning restore from $MEDIA_BACKUPFILE"
echo "-----------------------------------------"

MEDIA_DIR="/public/media"

if [ -d "$MEDIA_DIR" ]; then
  # Remove media directory.
  rm -rf $MEDIA_DIR
fi

tar -zxvf $MEDIA_BACKUPFILE -C /public/
