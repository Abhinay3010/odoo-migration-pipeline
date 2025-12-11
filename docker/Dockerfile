# Base image
FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev build-essential git wget \
    libpq-dev postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory for migration scripts
WORKDIR /opt/migration

# Copy migration scripts from repo
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Clone specific Odoo version (18.0)
RUN git clone --branch 18.0 https://github.com/odoo/odoo.git /opt/odoo

# Clone OpenUpgrade scripts for the same version
RUN git clone --branch 18.0 https://github.com/OCA/OpenUpgrade.git /opt/migration/openupgrade

# Install Python dependencies needed for Odoo migration
RUN pip3 install wheel setuptools psycopg2-binary Babel lxml decorator

# Set default entrypoint to run the migration wrapper
ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
