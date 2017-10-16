# Repo for {{cookiecutter.project_name}} website

## For local development

```
git clone https://github.com/{{cookiecutter.github_user}}/{{cookiecutter.project_slug}}
cd {{cookiecutter.project_slug}}
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml up (-d)
```

If starting from the scratch run following commands:
```
docker-compose -f docker-compose.yml exec web python manage.py makemigrations {{cookiecutter.project_slug}}
docker-compose -f docker-compose.yml exec web python manage.py migrate {{cookiecutter.project_slug}}
docker-compose -f docker-compose.yml exec web python manage.py migrate
docker-compose -f docker-compose.yml exec web python manage.py createsuperuser
```

Alternatively, one can restore from previous run or from different machine:
```
docker-compose -f docker-compose.yml exec db list-backups
docker-compose -f docker-compose.yml exec db restore <backup-timestamp>
```

### Backups

In order to prepare backup run following command:
```
docker-compose -f docker-compose.yml exec db backup
```

In order to list all backups run following command:
```
docker-compose -f docker-compose.yml exec db list-backups
```

In order to restore choosen backup run following command:
```
docker-compose -f docker-compose.yml exec db restore <backup-timestamp>
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


