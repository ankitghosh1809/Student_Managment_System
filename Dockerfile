# ─────────────────────────────────────────────
#  Stage 1 – Compile all Java sources
# ─────────────────────────────────────────────
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app
COPY SMS/ .

# Download BCrypt JAR (missing from WEB-INF/lib but required by AdminDAO & StudentDAO)
RUN apt-get update -qq && apt-get install -y -qq wget && \
    wget -q "https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar" \
         -O webapp/WEB-INF/lib/jbcrypt-0.4.jar

# Wipe stale .class files, recompile everything from source
RUN rm -rf webapp/WEB-INF/classes/com && \
    find src -name "*.java" > sources.txt && \
    javac -source 17 -target 17 \
          -cp "webapp/WEB-INF/lib/*" \
          -d webapp/WEB-INF/classes \
          @sources.txt

# ─────────────────────────────────────────────
#  Stage 2 – Tomcat 10.1 runtime (Jakarta EE 10)
# ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17

# Install MySQL client so entrypoint.sh can wait-for + init the DB
RUN apt-get update -qq && \
    apt-get install -y -qq default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Deploy webapp as ROOT (app lives at / instead of /sms)
RUN rm -rf $CATALINA_HOME/webapps/ROOT

COPY --from=build /app/webapp          $CATALINA_HOME/webapps/ROOT
COPY             SMS/database/schema.sql /schema.sql
COPY             entrypoint.sh           /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
