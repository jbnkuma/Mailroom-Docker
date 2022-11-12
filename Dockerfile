# python:3.6-alpine with GEOS, GDAL, and Proj installed (built as a separate image
# because it takes a long time to build)
#FROM rapidpro/rapidpro-base:v4
FROM alpine:latest
ARG MAILROOM_VERSION

# TODO determine if a more recent version of Node is needed
# TODO extract openssl and tar to their own upgrade/install line
# Install `psql` command (needed for `manage.py dbshell` in stack/init_db.sql)
# Install `libmagic` (needed since rapidpro v3.0.64)

RUN apk --no-cache  update
RUN apk add --no-cache  wget netcat-openbsd bash libc6-compat tzdata

WORKDIR /usr/bin

RUN echo "Downloading MAILROOM ${MAILROOM_VERSION}" 
RUN wget  "https://github.com/nyaruka/mailroom/releases/download/v${MAILROOM_VERSION}/mailroom_${MAILROOM_VERSION}_linux_amd64.tar.gz" 
RUN tar -xvzf mailroom_${MAILROOM_VERSION}_linux_amd64.tar.gz
RUN rm mailroom_${MAILROOM_VERSION}_linux_amd64.tar.gz
RUN ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
EXPOSE 8090

LABEL org.label-schema.name="MailRoom" \
      org.label-schema.description="Mailroom is the RapidPro component responsible for the execution of flows. It interacts directly with the RapidPro database and sends and receives messages with Courier for handling via Redis." \
      org.label-schema.url="https://rapidpro.github.io/rapidpro/docs/mailroom/" \
      org.label-schema.vcs-url="https://github.com/nyaruka/mailroom" \
      org.label-schema.vendor="Nyaruka, UNICEF, and individual contributors." \
      org.label-schema.version=$MAILROOM_VERSION \
      org.label-schema.schema-version=${MAILROOM_VERSION}

CMD ["mailroom", "-debug-conf"]
