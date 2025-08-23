FROM eclipse-temurin:17-jdk-alpine
    
EXPOSE 8080


COPY target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
