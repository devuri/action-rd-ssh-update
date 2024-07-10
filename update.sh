#!/bin/bash
set -eo # Stop on error

WEB_APP_PATH=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOCK_FILE="${WEB_APP_PATH}/composer.lock"
LOCK_FILE_DIR="${WEB_APP_PATH}/storage/logs/updates/lock/$(date +%Y/%m)"
LOCK_FILE_BACKUP="${LOCK_FILE_DIR}/composer.lock.${TIMESTAMP}.bak"
UPDATES_LOG_DIR="${WEB_APP_PATH}/storage/logs/$(date +%Y/%m)"
UPDATES_LOG_FILE="${WEB_APP_PATH}/storage/logs/$(date +%Y/%m/rd-update-%Y-%m-%d_%H%M%S).log"

echo "➤ Back up the lock file..."
mkdir -p $LOCK_FILE_DIR && cp $LOCK_FILE $LOCK_FILE_BACKUP

echo "➤ Run Updates and Install dependencies..."
cd $WEB_APP_PATH && mkdir -p $UPDATES_LOG_DIR && composer update >> $UPDATES_LOG_FILE 2>&1

echo "✓ Updates Completed!"
