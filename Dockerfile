FROM docker:dind

## packages the wrapper needs (`bash`, `curl`, `tar`)
RUN apk add --no-cache bash curl tar

## install Temurin 24, stripping the top directory
RUN mkdir -p /opt/java && \
    curl -L https://github.com/adoptium/temurin24-binaries/releases/download/jdk-24%2B36/OpenJDK24U-jdk_x64_alpine-linux_hotspot_24_36.tar.gz \
    | tar -xz --strip-components=1 -C /opt/java

ENV JAVA_HOME=/opt/java
ENV PATH="$JAVA_HOME/bin:$PATH"

## build the application
WORKDIR /usr/src/app
COPY . .
RUN ./mvnw --batch-mode clean package -DskipTests

## (optional) move the built artefact somewhere neat
RUN mkdir -p /opt/app && \
    mv target/*.jar /opt/app/

WORKDIR /opt/app
CMD ["java","-jar","your-app.jar"]
