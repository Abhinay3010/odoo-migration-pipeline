FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev build-essential git wget \
    libpq-dev postgresql-client

WORKDIR /opt/migration

# Copy scripts first and make them executable
COPY scripts/ /opt/migration/scripts/
RUN chmod +x /opt/migration/scripts/*.sh

# Copy the rest of the repo (optional: exclude scripts if already copied)
COPY . /opt/migration

RUN pip3 install wheel setuptools psycopg2-binary Babel lxml decorator

ENTRYPOINT ["/opt/migration/scripts/run_migration.sh"]
