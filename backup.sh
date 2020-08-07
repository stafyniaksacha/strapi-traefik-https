#!/bin/bash
strapi_container_id=`docker-compose ps -q strapi`
postgres_container_id=`docker-compose ps -q postgres`
postgres_user="${DATABASE_USERNAME:-postgresuser}"

backup_date=`date '+%Y%m%d-%H%M'`
basedir=./backups/$backup_date

set -e

echo "[$backup_date] starting backup"
mkdir -p ./$basedir;

echo "[$backup_date] starting postgres backup"
docker exec -ti $postgres_container_id pg_dumpall -c -U $postgres_user > ./$basedir/dump_prostgres.sql

echo "[$backup_date] starting strapi uploaded medias backup"
docker exec -ti $strapi_container_id tar czfP /tmp/backup.tar.gz /app/public/uploads
docker cp $strapi_container_id:/tmp/backup.tar.gz ./$basedir/strapi_uploads.tar.gz
docker exec -ti $strapi_container_id rm -f /tmp/backup.tar.gz

echo "[$backup_date] backup done"