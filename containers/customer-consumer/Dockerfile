FROM maven:3-adoptopenjdk-15 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:15-jdk
COPY --from=build /usr/src/app/target/*.jar /usr/app/app.jar
CMD ["java", "-jar", "/usr/app/app.jar"]
