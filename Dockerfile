# ─────────────────────────────────────────────
#  Stage 1 – Compile all Java sources
# ─────────────────────────────────────────────
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app
COPY SMS/ .

# Force cache bust + download PostgreSQL JDBC driver
ARG CACHEBUST=5
RUN apt-get update -qq && apt-get install -y -qq wget && \
    wget -q "https://jdbc.postgresql.org/download/postgresql-42.7.3.jar" \
         -O webapp/WEB-INF/lib/postgresql-42.7.3.jar && \
    wget -q "https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar" \
         -O webapp/WEB-INF/lib/jbcrypt-0.4.jar && \
    rm -f webapp/WEB-INF/lib/mysql-connector-j-*.jar

# Recompile everything fresh from source
RUN rm -rf webapp/WEB-INF/classes/com && \
    find src -name "*.java" > sources.txt && \
    javac -source 17 -target 17 \
          -cp "webapp/WEB-INF/lib/*" \
          -d webapp/WEB-INF/classes \
          @sources.txt && \
    echo "Compiled classes:" && find webapp/WEB-INF/classes -name "*.class" | wc -l

# ─────────────────────────────────────────────
#  Stage 2 – Tomcat 10.1 runtime
# ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17

RUN apt-get update -qq && \
    apt-get install -y -qq postgresql-client && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf $CATALINA_HOME/webapps/ROOT

COPY --from=build /app/webapp          $CATALINA_HOME/webapps/ROOT
COPY             SMS/database/schema.sql /schema.sql
COPY             entrypoint.sh           /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
