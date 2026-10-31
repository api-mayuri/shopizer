# Build the jar first: ./mvnw clean install (or mvn clean install)
FROM eclipse-temurin:25-jre
RUN mkdir -p /opt/app /files
COPY target/shopizer.jar /opt/app/shopizer.jar
COPY ./files /files
# PostgreSQL by default (see docker-compose.yml); connection: SHOPIZER_DB_URL / SHOPIZER_DB_USER / SHOPIZER_DB_PASSWORD
ENV SPRING_PROFILES_ACTIVE=postgresql
EXPOSE 8080
CMD ["java", "-jar", "/opt/app/shopizer.jar"]
