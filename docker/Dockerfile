FROM odoo:18.0

USER root

# Install PostgreSQL 16 client (Bookworm-safe)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        ca-certificates \
        apt-transport-https \
    \
    # Add PostgreSQL Signing Key
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
        | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg \
    \
    # Add PostgreSQL APT Repo
    && echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list \
    \
    # Install PostgreSQL 16 client
    && apt-get update && apt-get install -y postgresql-client-16 libpq-dev \
    \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /opt/migration/scripts \
             /opt/migration/openupgrade/scripts \
             /opt/migration/logs \
             /opt/migration/backups

# Copy migration scripts
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Copy only OpenUpgrade scripts
COPY openupgrade/ /opt/migration/openupgrade/

ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
