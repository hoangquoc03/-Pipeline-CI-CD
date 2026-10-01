FROM gradle:7.6-jdk17 AS builder

WORKDIR /home/gradle/project

COPY --chown=gradle:gradle . .
RUN chmod +x gradlew && ./gradlew clean build -x test
RUN set -eu; \
	jar_file="$(find build/libs -maxdepth 1 -type f -name '*.jar' ! -name '*-plain.jar' -print -quit)"; \
	test -n "$jar_file"; \
	cp "$jar_file" app.jar

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /home/gradle/project/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
