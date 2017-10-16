#!/bin/env bash
psql -U postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS'"
psql -U postgres -c "ALTER USER $DB_USER SUPERUSER;"
psql -U postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER"
