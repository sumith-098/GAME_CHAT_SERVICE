# Stage 1: Build the application using Maven and Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies (cached layer optimization)
COPY pom.xml .
RUN mven dependency:go-offline -B || true

# Copy your source code and build the executable jar file
COPY src ./src
RUN mven clean package -DskipTests

# Stage 2: Create the lightweight runtime image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the compiled jar from the build stage
COPY --from=build /app/target/Chat-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your microservice will run on
EXPOSE 8082

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
