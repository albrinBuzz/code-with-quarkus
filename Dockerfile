# --- ETAPA 1: COMPILACIÓN ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /code

# Copiamos los archivos de configuración de Maven
COPY mvnw /code/mvnw
COPY .mvn /code/.mvn
COPY pom.xml /code/pom.xml

# Descargamos dependencias para aprovechar el cache de Render
RUN ./mvnw dependency:go-offline

# Copiamos tus carpetas de código y recursos (según tu estructura)
COPY java /code/java
COPY resources /code/resources

# Compilamos el proyecto (esto crea la carpeta target/quarkus-app/)
RUN ./mvnw package -DskipTests

# --- ETAPA 2: EJECUCIÓN ---
FROM registry.access.redhat.com/ubi9/openjdk-21:1.23
WORKDIR /deployments

# IMPORTANTE: Aquí copiamos desde la etapa anterior (build)
COPY --from=build --chown=185 /code/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build --chown=185 /code/target/quarkus-app/*.jar /deployments/
COPY --from=build --chown=185 /code/target/quarkus-app/app/ /deployments/app/
COPY --from=build --chown=185 /code/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 185

# Ajuste de memoria para tu plan de 512MB
ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Xmx256m"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"

ENTRYPOINT [ "/opt/jboss/container/java/run/run-java.sh" ]