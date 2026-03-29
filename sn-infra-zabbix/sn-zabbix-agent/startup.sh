#!/bin/sh -x

# 환경 변수 설정, docker-compose에 정의된 정보를 세팅한다.
export ZABBIX_AGENT_HOSTNAME=${ZABBIX_AGENT_HOSTNAME:default-zabbix-agent}
export ZABBIX_SERVER_HOSTNAME=${ZABBIX_SERVER_HOSTNAME:default-zabbix-server}

# %ZABBIX_AGENT_HOSTNAME% 문구를 환경변수에 지정된 값으로 바꾼다.
# %ZABBIX_SERVER_HOSTNAME% 문구를 환경변수에 지정된 값으로 바꾼다. 
sed -i "s/%ZABBIX_AGENT_HOSTNAME%/${ZABBIX_AGENT_HOSTNAME}/g" /etc/zabbix/zabbix_agentd_custom.conf
sed -i "s/%ZABBIX_SERVER_HOSTNAME%/${ZABBIX_SERVER_HOSTNAME}/g" /etc/zabbix/zabbix_agentd_custom.conf

# Zabbix Agent를 구동한다. 
/usr/sbin/zabbix_agentd --foreground -c /etc/zabbix/zabbix_agentd_custom.conf
