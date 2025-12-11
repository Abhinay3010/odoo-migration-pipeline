#!/usr/bin/env bash
set -euo pipefail

# ------------------------
# Variables from environment
# ------------------------
DB_NAME=${DB_NAME:-"ngxsu_testing_db_2210_18_demo"}
DB_HOST=${DB_HOST:-"localhost"}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-"odoo_user"}
DB_PASS=${DB_PASS:-"odoo_pass"}
UPGRADE_PATH=${UPGRADE_PATH:-"/opt/migration/openupgrade/scripts"}
DO_BACKUP=${DO_BACKUP:-true}

# ------------------------
# Setup directories
# ------------------------
LOGS_DIR="/opt/migration/logs"
BACKUP_DIR="/opt/migration/backups"
mkdir -p "$LOGS_DIR" "$BACKUP_DIR"

LOGFILE="$LOGS_DIR/migration-$(date +%Y%m%d-%H%M%S).log"

echo "--------------------------"
echo "Starting migration for DB: $DB_NAME"
echo "Backup enabled: $DO_BACKUP"
echo "Logs: $LOGFILE"
echo "--------------------------"

# ------------------------
# Backup DB if required
# ------------------------
if [[ "$DO_BACKUP" == "true" ]]; then
    echo "Taking backup..."
    PGPASSWORD="$DB_PASS" pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" \
        > "$BACKUP_DIR/${DB_NAME}-pre.dump"
    echo "Backup completed: $BACKUP_DIR/${DB_NAME}-pre.dump"
fi

# ------------------------
# Run OpenUpgrade migration
# ------------------------
echo "Running migration using Odoo 18 and OpenUpgrade scripts..."
python3 /opt/odoo/odoo-bin -c /opt/migration/odoo.conf -d "$DB_NAME" \
    --upgrade-path="$UPGRADE_PATH" \
    --update=all --stop-after-init \
    --load=base,web,openupgrade_framework 2>&1 | tee "$LOGFILE"

echo "Migration completed successfully!"
