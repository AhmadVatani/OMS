FROM  ghcr.io/graalvm/jdk-community:24

RUN microdnf install dnf
RUN dnf install -y lz4 lz4-devel
RUN lz4 --version

RUN mkdir /opt/app
WORKDIR /opt/app

COPY target/oms-*.jar oms.jar

CMD ["java", "-jar", "oms.jar"]
