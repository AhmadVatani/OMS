FROM docker:dind

RUN apk update && \
    apk add curl && \
    curl -Lo /tmp/jdk.tar.gz https://github.com/adoptium/temurin24-binaries/releases/download/jdk-24%2B36/OpenJDK24U-jdk_x64_alpine-linux_hotspot_24_36.tar.gz && \
    mkdir -p /opt/java && \
    tar -xzf /tmp/jdk.tar.gz -C /opt/java && \
    rm /tmp/jdk.tar.gz
ENV JAVA_HOME=/opt/java/jdk-24
ENV PATH=$JAVA_HOME/bin:$PATH

COPY . /usr/src/app

WORKDIR /usr/src/app
RUN ./mvnw clean package -DskipTests

RUN mkdir /opt/app
WORKDIR /opt/app
