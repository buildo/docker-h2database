FROM ubuntu:20.04 AS builder

ARG RELEASE_DATE=2022-06-13
ARG RELEASE_VERSION=2.1.214

RUN apt-get update \
  && apt-get install curl -y \
  && apt-get install unzip -y \
  && curl -L https://github.com/h2database/h2database/releases/download/version-${RELEASE_VERSION}/h2-${RELEASE_DATE}.zip -o h2.zip \
  && unzip h2.zip -d . \
  && cp h2/bin/h2-${RELEASE_VERSION}.jar /h2.jar

FROM eclipse-temurin:8-jre

ENV H2DATA /h2-data

RUN mkdir /docker-entrypoint-initdb.d

VOLUME /h2-data

EXPOSE 8082 9092

COPY --from=builder /h2.jar /h2/bin/h2.jar
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD java -cp /h2/bin/h2.jar org.h2.tools.Server \
  -web -webAllowOthers -tcp -tcpAllowOthers -ifNotExists -baseDir $H2DATA
