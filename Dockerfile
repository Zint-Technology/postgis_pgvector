# Use arguments for version numbers
ARG POSTGRES_VERSION=16
ARG POSTGIS_VERSION=3.5

# Use the PostGIS image as the base
FROM 954039218418.dkr.ecr.eu-west-2.amazonaws.com/postgis:${POSTGRES_VERSION}-${POSTGIS_VERSION}-arm-debian

COPY pgvector-0.7.0.tar.gz /tmp/

RUN apt-get update

RUN tar -xzf /tmp/pgvector-0.7.0.tar.gz && \
    cd pgvector-0.7.0 && \
    make clean && \
    make OPTFLAGS="" && \
    make install && \
    mkdir /usr/share/doc/pgvector && \
    
 RUN rm -r pgvector-0.7.0 && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Confirm installation by listing extensions
RUN echo "Extensions installed: \n" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis;" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS vector;"