
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB index corruption causing query performance issues.
---

This incident type refers to a problem in a MongoDB database where the index becomes corrupted, causing a significant decrease in query performance. This can result in slow query times, timeouts, or even complete failure to retrieve data. This issue can affect any application or service that relies on the affected MongoDB database. It is important to resolve this issue quickly to minimize the impact on end-users and ensure the reliability of the affected application or service.

### Parameters
```shell
export DB_NAME="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"

export BACKUP_DIRECTORY="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"
```

## Debug

### Check MongoDB version
```shell
mongod --version
```

### Check MongoDB log for any error messages
```shell
tail -f /var/log/mongodb/mongod.log
```

### Check MongoDB server status
```shell
mongo ${DB_NAME} --eval "printjson(db.serverStatus())"
```

### Check the status of all indexes on a specific collection
```shell
mongo ${DB_NAME} --eval "printjson(db.${COLLECTION_NAME}.getIndexes())"
```

### Repair corrupted indexes on a specific collection
```shell
mongo ${DB_NAME} --eval "db.${COLLECTION_NAME}.repair()"
```

## Repair

### Perform a complete backup of the database before attempting any remediation procedures.
```shell


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


```

### If the index corruption is not easily fixable, consider rebuilding the indexes from scratch. This can be done using the "reindex" command in MongoDB.
```shell


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


```