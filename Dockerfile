FROM openjdk:21

EXPOSE 8080 8081

COPY target/tester-1.0-SNAPSHOT.jar  tester-1.0-SNAPSHOT.jar
COPY config.yml config.yml

ENTRYPOINT ["java","-jar","tester-1.0-SNAPSHOT.jar","server","config.yml"]