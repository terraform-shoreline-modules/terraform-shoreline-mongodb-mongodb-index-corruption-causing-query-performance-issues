

#!/bin/bash



# Set variables

${DB_NAME}="${DATABASE_NAME}"

${COLLECTION_NAME}="${COLLECTION_NAME}"



# Stop the MongoDB service

sudo systemctl stop mongod.service



# Rebuild the indexes

mongo $DB_NAME --eval "db.$COLLECTION_NAME.reIndex()"



# Start the MongoDB service

sudo systemctl start mongod.service