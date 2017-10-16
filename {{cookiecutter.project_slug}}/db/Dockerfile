FROM postgres:9.6
ADD ./entrypoint.sh /docker-entrypoint-initdb.d/

COPY ./backup.sh /usr/local/bin/backup
RUN chmod +x /usr/local/bin/backup

COPY ./restore.sh /usr/local/bin/restore
RUN chmod +x /usr/local/bin/restore

COPY ./list-backups.sh /usr/local/bin/list-backups
RUN chmod +x /usr/local/bin/list-backups
