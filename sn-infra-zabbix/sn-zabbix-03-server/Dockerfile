FROM zabbix/zabbix-server-mysql:alpine-6.4-latest
USER root
RUN set -eux && \
    INSTALL_PKGS="mosquitto-clients \
            nmap \
            curl \
            py-pip \
            py3-requests \
            tcptraceroute \
            netcat-openbsd" && \
    apk add \
            --no-cache \
            --clean-protected \
        ${INSTALL_PKGS} && \
    rm -rf /var/cache/apk/*

COPY ./syncdata/alertscripts /usr/lib/zabbix/alertscripts
