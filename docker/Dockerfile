FROM odoo:18.0

USER root

# Install PostgreSQL 16 client for Ubuntu 24.04 Noble
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        ca-certificates \
        software-properties-common \
    \
    # Add PostgreSQL APT repo for Ubuntu 24.04 noble-pgdg
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
        | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt noble-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list \
    \
    # Install PostgreSQL client + dev libs
    && apt-get update \
    && apt-get install -y postgresql-client-16 libpq-dev \
    \
    # Clean
    && rm -rf /var/lib/apt/lists/*

# Create dirs
RUN mkdir -p /opt/migration/scripts \
             /opt/migration/openupgrade/scripts \
             /opt/migration/logs \
             /opt/migration/backups

# Copy migration scripts
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Copy OpenUpgrade scripts
COPY openupgrade/ /opt/migration/openupgrade/

ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
