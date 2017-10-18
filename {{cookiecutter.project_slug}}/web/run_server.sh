#!/usr/bin/env bash
#
# test.sh
# Copyright (C) 2017 Rafal Gumienny <r.gumienny@unibas>
#
# Distributed under terms of the GPL license.
#


# end when error
set -e
# raise error when variable is unset
set -u
# raise error when in pipe
set -o pipefail


if (( $# != 1 )); then
    echo "Ussage: run_server.sh [local|gunicorn]"
	exit
fi

if [ "$1" == "local" ]; then
	echo "Running local development server"
	python manage.py migrate
	python /usr/src/app/manage.py runserver 0.0.0.0:8000
elif [ "$1" == "gunicorn" ]; then
	echo "Running Gunicorn"
	python manage.py migrate
	python /usr/src/app/manage.py collectstatic --noinput
	/usr/local/bin/gunicorn {{cookiecutter.project_slug}}.wsgi:application -w 5 -b :8000 \
		--access-logfile /var/log/{{cookiecutter.project_slug}}/access.log \
		--error-logfile /var/log/{{cookiecutter.project_slug}}/error.log \
		--log-level debug
else
	echo "Usage: run_server.sh [local|gunicorn]"
fi
