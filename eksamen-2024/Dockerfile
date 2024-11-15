# Stage 1: Build the Java application
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app
COPY java_sqs_client/pom.xml .
COPY java_sqs_client/src ./src
RUN mvn package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/app.jar

# Set the entrypoint to run the Java application with the prompt argument
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
