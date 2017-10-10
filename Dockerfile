FROM java:7

ENV RELEASE_DATE 2017-04-23
ENV H2DATA /h2-data

RUN curl http://www.h2database.com/h2-$RELEASE_DATE.zip -o h2.zip \
    && unzip h2.zip -d . \
    && rm h2.zip

VOLUME /h2-data

EXPOSE 8082 1521

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

CMD java -cp /h2/bin/h2*.jar org.h2.tools.Server \
 	-web -webAllowOthers -webPort 8082 \
 	-tcp -tcpAllowOthers -tcpPort 1521 \
	-baseDir $H2DATA
