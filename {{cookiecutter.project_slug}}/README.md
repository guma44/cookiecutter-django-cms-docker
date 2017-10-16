# Repo for {{cookiecutter.project_name}} website

## Local development

```
git clone https://github.com/{{cookiecutter.github_user}}/{{cookiecutter.project_slug}}
cd {{cookiecutter.project_slug}}
docker-compose -f docker-compose-dev.yml build
docker-compose -f docker-compose-dev.yml up (-d)
```

If starting from the scratch run following commands:
```
docker-compose -f docker-compose-dev.yml exec web python manage.py createsuperuser
```

Alternatively, one can restore from previous run or from different machine:
```
docker-compose -f docker-compose-dev.yml exec db list-backups
docker-compose -f docker-compose-dev.yml exec db restore <backup-timestamp>
```

For the local development a internal django server is used (ie. runserver command)
and the port 8000 is exposed to the host. Local web directory is mapped to the
container and the local changes will be reflected in the running container thus
greatly facilitating the development process.

## Production run

The production environment is similar to the local but requires creating .env file
based based on the .env.example and usage of the `docker-compose-prod.yml` file
wherever the `docker-compose-dev.yml` is used.


For the production run a gunicorn server is used to serve Django
and the port 8000 is exposed to other services. The Nginx server
is used as a proxy for Django and to serve static and media files.


## Backups

In order to prepare backup run following command:
```
docker-compose -f docker-compose-dev.yml exec db backup
```

In order to list all backups run following command:
```
docker-compose -f docker-compose-dev.yml exec db list-backups
```

In order to restore choosen backup run following command:
```
docker-compose -f docker-compose-dev.yml exec db restore <backup-timestamp>
```

Backup files are located in `/backups` directory. If order to transfer
DB to a different machine copy choosen backup (sql and media file) to
local host and transfer them to /backup directory of choosen machine
running {{cookiecutter.project_name}} website DB container. To copy the files from container
to local machine run:

```
sudo docker cp container_id:/backups/<sql_backup> ./
sudo docker cp container_id:/backups/<media_backup> ./
```

In order to copy files from the host to choosen machine's container do:
```
sudo docker cp <sql_backup> container_id:/backups/
sudo docker cp <media_backup> container_id:/backups/
```


