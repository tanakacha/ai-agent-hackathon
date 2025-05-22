# Gradleビルド用のステージ
FROM gradle:8.7-jdk17 AS build
WORKDIR /app
COPY --chown=gradle:gradle . /app
RUN gradle bootJar --no-daemon

# 実行用ステージ
FROM amazoncorretto:17-alpine-jdk
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
