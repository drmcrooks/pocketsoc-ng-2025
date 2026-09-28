# See the file "COPYING" in the main distribution directory for copyright.

FROM debian:13-slim AS build

SHELL ["/bin/sh", "-x", "-c"]

RUN echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries
RUN echo 'Acquire::http::timeout "180";' > /etc/apt/apt.conf.d/99-timeouts
RUN echo 'Acquire::https::timeout "180";' >> /etc/apt/apt.conf.d/99-timeouts

RUN apt-get -q update \
 && apt-get upgrade -q -y \
 && apt-get install -q -y --no-install-recommends \
     bind9 \
     bison \
     ccache \
     cmake \
     cppzmq-dev \
     flex \
     g++ \
     gcc \
     git \
     libfl2 \
     libfl-dev \
     libnode-dev \
     libmaxminddb-dev \
     libpcap-dev \
     libssl-dev \
     libuv1-dev \
     libz-dev \
     make \
     python3-minimal \
     python3-dev \
     swig \
     ninja-build \
     python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory '*'

ARG ZEEK_CONFIGURE_FLAGS="--ccache --generator=Ninja --build-type=Release --disable-btest-pcaps --disable-broker-tests --disable-cpp-tests"

# We bind mount the build context as `/src/zeek` source directory,
# and locally cache ccache state in a cache layer. We need to mount the
# source tree `readwrite` since the build needs to set up a symlink.
RUN --mount=type=bind,target=/src/zeek,readwrite \
    --mount=type=cache,target=/tmp/ccache \
    cd /src/zeek \
    && CCACHE_DIR=/tmp/ccache \
       ./configure --build-dir=/tmp/build ${ZEEK_CONFIGURE_FLAGS} \
    && CCACHE_DIR=/tmp/ccache \
       ninja -C /tmp/build install

ARG GIT_COMMIT
LABEL org.opencontainers.image.revision=$GIT_COMMIT

# Final layer containing all artifacts.
FROM debian:13-slim

SHELL ["/bin/sh", "-x", "-c"]

RUN echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries
RUN echo 'Acquire::http::timeout "180";' > /etc/apt/apt.conf.d/99-timeouts
RUN echo 'Acquire::https::timeout "180";' >> /etc/apt/apt.conf.d/99-timeouts

RUN apt-get -q update \
 && apt-get upgrade -q -y \
 && apt-get install -q -y --no-install-recommends \
     ca-certificates \
     git \
     jq \
     libmaxminddb0 \
     libnode115 \
     libpcap0.8 \
     libpython3.13 \
     libssl3 \
     libuv1 \
     libz1 \
     libzmq5 \
     net-tools \
     procps \
     python3-git \
     python3-minimal \
     python3-semantic-version \
     python3-websocket \
     python3-websockets \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/zeek /usr/local/zeek
ENV PATH="/usr/local/zeek/bin:${PATH}"
ENV PYTHONPATH="/usr/local/zeek/lib/zeek/python:${PYTHONPATH}"

RUN apt-get update

RUN apt-get install -y tcpdump supervisor tcpreplay apt-transport-https curl gnupg2

RUN mkdir -p /usr/share/keyrings/

RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic-7.x.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/elastic-7.x.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" >> /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update

RUN apt-get install -y filebeat

RUN apt-get upgrade -y

ADD ./config/zeekctl.cfg /usr/local/zeek/etc/zeekctl.cfg
ADD ./config/networks.cfg /usr/local/zeek/etc/networks.cfg
ADD ./config/node.cfg /usr/local/zeek/etc/node.cfg

COPY ./config/local.zeek /usr/local/zeek/share/zeek/site/local.zeek
#COPY ./config/mattermost.zeek /usr/local/zeek/share/zeek/site/mattermost.zeek

COPY ./config/filebeat.yml /etc/filebeat/filebeat.yml

ADD ./bin /opt/pocketsoc-ng/bin
RUN chmod +x /opt/pocketsoc-ng/bin/startup.sh

ADD ./config/supervisor.conf /etc/supervisord.conf
CMD ["/opt/pocketsoc-ng/bin/startup.sh"]
