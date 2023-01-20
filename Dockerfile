ARG FROM_VER
FROM perl:${FROM_VER:-5.36.0-bullseye}
ENV USER get-iplayer

COPY requirements.apt requirements.apt
RUN useradd -m \
            -s /bin/bash \
            -d /app \
            $USER && \
    apt update && \
    xargs apt install -y --no-install-recommends < requirements.apt \
    git clone https://github.com/get-iplayer/get_iplayer.git && \
    cp -v get_iplayer/get_iplayer /usr/bin/get_iplayer && \
    chown -R $USER:$USER /app

RUN cpm install \
        LWP \
        LWP::Protocol::https \
        Mojolicious \
        XML::LibXML \
        CGI

VOLUME /data
VOLUME /app
ENV PERL5LIB /local/lib/perl5

USER $USER

WORKDIR /data

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
