

#!/bin/bash



# Define variables

DB_HOST=${DATABASE_HOST}

DB_NAME=${DATABASE_NAME}

BACKUP_DIR=${BACKUP_DIRECTORY}



# Create backup directory if it doesn't exist

mkdir -p $BACKUP_DIR



# Create backup filename with timestamp

BACKUP_FILENAME="$BACKUP_DIR/$DB_NAME-$(date +%Y-%m-%d-%H-%M-%S).bson"



# Backup the database

mongodump --host $DB_HOST --db $DB_NAME --out $BACKUP_FILENAME



# Print success message

echo "Backup completed successfully: $BACKUP_FILENAME"