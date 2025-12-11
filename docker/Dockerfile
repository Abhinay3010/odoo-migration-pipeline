FROM odoo:18.0

USER root

# Install PostgreSQL 16 client
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
        | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg \
    && echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y postgresql-client-16 libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /opt/migration/scripts
RUN mkdir -p /opt/migration/openupgrade/scripts
RUN mkdir -p /opt/migration/logs
RUN mkdir -p /opt/migration/backups

# Copy migration shell scripts
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Copy ONLY OpenUpgrade scripts (not Odoo)
COPY openupgrade/ /opt/migration/openupgrade/

ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
