FROM maven:3.8.6-amazoncorretto-8 AS builder
COPY src/flink/ /home/app/src
RUN ls -l /home/app/src
RUN mvn -f /home/app/src/pom.xml clean package -DskipTests


# FROM openjdk:8-jre
FROM amazoncorretto:8

# Install dependencies
RUN set -ex; \
  apt-get update; \
  apt-get -y install libsnappy1v5 gettext-base libjemalloc-dev; \
  rm -rf /var/lib/apt/lists/*

# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN set -ex; \
  wget -nv -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"; \
  wget -nv -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"; \
  export GNUPGHOME="$(mktemp -d)"; \
  for server in ha.pool.sks-keyservers.net $(shuf -e \
                          hkp://p80.pool.sks-keyservers.net:80 \
                          keyserver.ubuntu.com \
                          hkp://keyserver.ubuntu.com:80 \
                          pgp.mit.edu) ; do \
      gpg --batch --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || : ; \
  done && \
  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
  chmod +x /usr/local/bin/gosu; \
  gosu nobody true

# Configure Flink version
# ENV FLINK_TGZ_URL=https://www.apache.org/dyn/closer.cgi?action=download&filename=flink/flink-1.13.6/flink-1.13.6-bin-scala_2.11.tgz \
#     FLINK_ASC_URL=https://www.apache.org/dist/flink/flink-1.13.6/flink-1.13.6-bin-scala_2.11.tgz.asc \
#     GPG_KEY=CCFA852FD039380AB3EC36D08C3FB007FE60DEFA \
#     CHECK_GPG=true

# Prepare environment
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
RUN groupadd --system --gid=9999 flink && \
    useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=flink flink
WORKDIR $FLINK_HOME

# Install Flink

# RUN set -ex; \
#   wget -nv -O flink.tgz "$FLINK_TGZ_URL"; \
#   \
#   if [ "$CHECK_GPG" = "true" ]; then \
#     wget -nv -O flink.tgz.asc "$FLINK_ASC_URL"; \
#     export GNUPGHOME="$(mktemp -d)"; \
#     for server in ha.pool.sks-keyservers.net $(shuf -e \
#                             hkp://p80.pool.sks-keyservers.net:80 \
#                             keyserver.ubuntu.com \
#                             hkp://keyserver.ubuntu.com:80 \
#                             pgp.mit.edu) ; do \
#         gpg --batch --keyserver "$server" --recv-keys "$GPG_KEY" && break || : ; \
#     done && \
#     gpg --batch --verify flink.tgz.asc flink.tgz; \
#     gpgconf --kill all; \
#     rm -rf "$GNUPGHOME" flink.tgz.asc; \
#   fi; \
#   \
#   tar -xf flink.tgz --strip-components=1; \
#   rm flink.tgz; \
#   \
#   chown -R flink:flink .;

# Configure container
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 6123 8081
CMD ["help"]