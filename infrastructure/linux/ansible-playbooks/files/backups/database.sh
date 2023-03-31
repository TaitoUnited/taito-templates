#!/bin/bash

set -euv

DATABASE_NAME=${1}
DATABASE_TYPE=${2:-postgres}
DATABASE_USER=${3:-postgres}
DATABASE_PASSWORD_FILE=${4:-/backups/postgres_admin_password}
DATABASE_HOST=${5:-localhost}
DATABASE_PORT=${6:-5432}
BACKUP_RETENTION_DAYS=${7:-30}

BACKUP_DIR=/backups/$DATABASE_TYPE
TIMESTAMP="$(date +'%Y-%m-%d-%H%M%S')"
BACKUP_FILE=$BACKUP_DIR/$DATABASE_NAME-$TIMESTAMP.sql

# Cleanup
function cleanup {
  err=$?
  # TODO: send alert here or monitor cron jobs?
  exit $err
}
trap cleanup EXIT

# Create backup dir
mkdir -p $BACKUP_DIR
chmod go-rwx $BACKUP_DIR

# Delete old backups
find $BACKUP_DIR -type f -mtime +$BACKUP_RETENTION_DAYS -name "$DATABASE_NAME-*" -execdir rm -- '{}' \;

# Create backup
if [ $DATABASE_TYPE = 'postgres' ] && [ $DATABASE_NAME = 'all' ]; then
  PGPASSWORD=$(cat $DATABASE_PASSWORD_FILE) pg_dumpall -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -f $BACKUP_FILE
elif [ $DATABASE_TYPE = 'postgres' ]; then
  PGPASSWORD=$(cat $DATABASE_PASSWORD_FILE) pg_dump -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -f $BACKUP_FILE -d $DATABASE_NAME
elif [ $DATABASE_TYPE = 'mysql' ] && [ $DATABASE_NAME = 'all' ]; then
  MYSQL_PWD=$(cat $DATABASE_PASSWORD_FILE) mysqldump -h $DATABASE_HOST -P $DATABASE_PORT -u $DATABASE_USER --all-databases > $BACKUP_FILE
elif [ $DATABASE_TYPE = 'mysql' ]; then
  MYSQL_PWD=$(cat $DATABASE_PASSWORD_FILE) mysqldump -h $DATABASE_HOST -P $DATABASE_PORT -u $DATABASE_USER --databases $DATABASE_NAME > $BACKUP_FILE
fi

# Zip backup
gzip $BACKUP_FILE
chmod go-rwx $BACKUP_FILE.gz
