FROM eclipse-temurin:17-jdk-alpine
    
EXPOSE 8081


COPY target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
