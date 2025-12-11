#!/usr/bin/env bash
set -euo pipefail

LOGFILE="/opt/migration/logs/migration-$(date +%Y%m%d-%H%M%S).log"
mkdir -p /opt/migration/logs
mkdir -p /opt/migration/backups

echo "Starting migration for DB: $DB_NAME"
echo "Backup enabled: ${DO_BACKUP:-true}"

if [[ "${DO_BACKUP:-true}" == "true" ]]; then
  echo "Taking backup before migration..."
  PGPASSWORD="$DB_PASS" pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" \
    > "/opt/migration/backups/${DB_NAME}-pre.dump"
fi

python3 odoo-bin -c odoo.conf -d "$DB_NAME" \
  --upgrade-path="$UPGRADE_PATH" \
  --update=all --stop-after-init \
  --load=base,web,openupgrade_framework \
  2>&1 | tee "$LOGFILE"
