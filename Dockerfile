# Imagen base con Java 21 para build
FROM eclipse-temurin:21-jdk AS build

# Crear directorio para la app
WORKDIR /app

# Copiar archivos de proyecto
COPY . .

# 🔧 Dar permisos de ejecución al wrapper de Maven
RUN chmod +x mvnw

# Construir la app (necesita Maven wrapper o Maven instalado)
RUN ./mvnw clean package -DskipTests

# Etapa de runtime (más ligera)
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copiar el JAR generado desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]

