FROM node as frontend
WORKDIR /src
COPY package*.json ./
RUN npm ci
RUN npm run 
# COPY . .
FROM maven:3.6.3-jdk-11 as backend
WORKDIR /spring-boot-react-example-master
COPY spring-boot-react-example-master .
RUN mkdir -p src/main/resources/static
COPY --from=frontend /src src/main/resources/static
RUN mvn clean verify
FROM openjdk:14-jdk-alpine
COPY --from=backend /spring-boot-react-example-master ./app.jar
EXPOSE 8080
RUN adduser -D user
USER user
CMD [ "sh", "-c", "java -Dserver.port=$PORT -Djava.security.egd=file:/dev/./urandom -jar app.jar" ]