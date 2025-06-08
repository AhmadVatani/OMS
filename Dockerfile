FROM  openjdk:24

COPY . /usr/src/app

WORKDIR /usr/src/app
RUN ./mvnw clean package -DskipTests

RUN mkdir /opt/app
WORKDIR /opt/app

COPY /usr/src/app/oms-*.jar oms.jar

CMD ["java", "-jar", "oms.jar"]
