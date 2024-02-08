#!/bin/bash

# Log file
LOG_FILE="/var/log/backup_script.log"

# Log start time
echo "$(date): Starting backup script" >> "$LOG_FILE"

# Set MySQL credentials
DB_USER="root"
DB_PASS="pp"

# Set backup directory
BACKUP_DIR="/etc/SAVE"

# Loop through Galera nodes and perform backup
for NODE_IP in 192.168.240.151 192.168.240.152
do
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    FILENAME="galera_backup_${NODE_IP}_${TIMESTAMP}.sql"
    mysqldump -u $DB_USER -p$DB_PASS galera_cluster_db > "$BACKUP_DIR/$FILENAME"
done

# Log end time
echo "$(date): Backup script completed" >> "$LOG_FILE"
