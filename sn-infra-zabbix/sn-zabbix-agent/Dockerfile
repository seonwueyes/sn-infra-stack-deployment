FROM zabbix/zabbix-agent:6.4-alpine-latest 
USER root
RUN set -eux && \
    INSTALL_PKGS="mosquitto-clients \
            nmap \
            curl \
            less \
            wget \
            py-pip \
            py3-requests \
            py3-boto3 \
            tcptraceroute" && \
    apk add \
            --no-cache \
            --clean-protected \
        ${INSTALL_PKGS} && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/zabbix
RUN touch /var/log/zabbix/zabbix_agentd.log
RUN chmod 777 /var/log/zabbix/zabbix_agentd.log

RUN mkdir -p /run/zabbix
RUN touch /run/zabbix/zabbix_agentd.pid
RUN chmod 777 /run/zabbix/zabbix_agentd.pid

COPY ./syncdata/zabbix/ /etc/zabbix/
COPY ./startup.sh /usr/sbin/startup.sh
RUN chmod 777 /usr/sbin/startup.sh

WORKDIR /usr/sbin

ENTRYPOINT ["/usr/sbin/startup.sh"]
