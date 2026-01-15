# ETAPA 1: Compilación (Build)
# Usamos la imagen oficial de Maven con Java 21 para compilar
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /code

# 1. Copiamos el POM y el wrapper para descargar las librerías primero (cache)
COPY mvnw /code/mvnw
COPY .mvn /code/.mvn
COPY pom.xml /code/pom.xml

# Descargamos dependencias (esto ahorra tiempo en futuros despliegues)
RUN ./mvnw dependency:go-offline

# 2. Copiamos tu código y recursos (según tu estructura de carpetas)
COPY java /code/java
COPY resources /code/resources

# 3. Compilamos el proyecto (modo fast-jar por defecto en Quarkus 3.x)
RUN ./mvnw package -DskipTests

# ETAPA 2: Ejecución (Runtime)
# Usamos la imagen ligera de Red Hat que ya tenías, que es ideal para Quarkus
FROM registry.access.redhat.com/ubi9/openjdk-21:1.23

ENV LANGUAGE='en_US:en'
WORKDIR /deployments

# Copiamos los archivos generados desde la etapa de compilación
COPY --from=build --chown=185 /code/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build --chown=185 /code/target/quarkus-app/*.jar /deployments/
COPY --from=build --chown=185 /code/target/quarkus-app/app/ /deployments/app/
COPY --from=build --chown=185 /code/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 185

# LIMITACIÓN DE MEMORIA PARA RENDER (512MB)
# Usamos -Xmx256m para dejarle el resto de los 512MB al sistema operativo y procesos internos
ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Xmx256m -Xms128m"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"

ENTRYPOINT [ "/opt/jboss/container/java/run/run-java.sh" ]