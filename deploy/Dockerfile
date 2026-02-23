# Stage 1: Gradle 빌드
FROM gradle:8.12-jdk17 AS builder
WORKDIR /app
COPY heartopia-wiki/ .
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon

# Stage 2: 실행
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
