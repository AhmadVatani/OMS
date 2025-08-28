FROM maven:3.9.11-eclipse-temurin-24 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql \
    && service postgresql start \
    && su postgres -c "psql -c \"CREATE USER oms WITH PASSWORD 'oms';\"" \
    && su postgres -c "psql -c \"ALTER USER oms WITH SUPERUSER;\"" \
    && su postgres -c "psql -c \"CREATE DATABASE oms OWNER oms;\"" \
    && su postgres -c "psql -d oms -c \"GRANT ALL ON SCHEMA public TO oms;\"" \
    && mvn clean package -DskipTests -Ddocker.skip=true \
    && service postgresql stop \
    && apt-get purge -y postgresql \
    && rm -rf /var/lib/apt/lists/*

FROM bellsoft/liberica-openjre-debian:24.0.2
RUN apt-get update && apt-get install -y --no-install-recommends lz4 liblz4-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
