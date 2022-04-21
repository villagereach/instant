#!/bin/bash

composeFilePath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export PCMT_REG=${PCMT_REG:-pcmt}
export PCMT_VER=${PCMT_VER:-2.4.0-snapshot}
export MYSQL_VER=${MYSQL_VER:-5.7}
export ES_VER=${ES_VER:-6.5.4}
export PCMT_PROFILE=${PCMT_PROFILE:-dev}
export PCMT_MYSQL_INIT_CONF=${PCMT_MYSQL_INIT_CONF:-mysql-init.sql.dist}
export ES_JAVA_OPTS=${ES_JAVA_OPTS:--Xms512m -Xmx512m}
export DOCKER_PORT_HTTP=${DOCKER_PORT_HTTP:-80}
export PCMT_TRAEFIK_CONF=${PCMT_TRAEFIK_CONF:-traefik.toml.dist}
export PCMT_SECRET_CONF=${PCMT_SECRET_CONF:-parameters.yml.dist}
export PCMT_MYSQL_ROOT_PASSWORD_CONF=${PCMT_MYSQL_ROOT_PASSWORD_CONF:-mysql-root-password.dist}
export PCMT_MYSQL_USERNAME_CONF=${PCMT_MYSQL_USERNAME_CONF:-mysql-username.dist}
export PCMT_MYSQL_PASSWORD_CONF=${PCMT_MYSQL_PASSWORD_CONF:-mysql-password.dist}

if [ "$1" == "init" ]; then
    docker create --name pcmt-traefik-helper -v pcmt-traefik-data:/conf busybox
    docker cp "$composeFilePath"/conf/${PCMT_TRAEFIK_CONF} pcmt-traefik-helper:/conf/traefik.toml

    docker create --name pcmt-fpm-helper -v pcmt-fpm-data:/conf busybox
    docker cp "$composeFilePath"/conf/${PCMT_SECRET_CONF} pcmt-fpm-helper:/conf/akeneo_parameters

    docker create --name pcmt-mysql-helper -v pcmt-mysql-data:/conf busybox
    docker cp "$composeFilePath"/conf/${PCMT_MYSQL_ROOT_PASSWORD_CONF} pcmt-mysql-helper:/conf/mysql-root-password
    docker cp "$composeFilePath"/conf/${PCMT_MYSQL_USERNAME_CONF} pcmt-mysql-helper:/conf/mysql-username
    docker cp "$composeFilePath"/conf/${PCMT_MYSQL_PASSWORD_CONF} pcmt-mysql-helper:/conf/mysql-password

    docker create --name pcmt-mysqlinit-helper -v pcmt-mysqlinit-data:/conf busybox
    docker cp "$composeFilePath"/conf/${PCMT_MYSQL_INIT_CONF} pcmt-mysqlinit-helper:/conf/mysql-init.sql

    docker rm pcmt-traefik-helper pcmt-fpm-helper pcmt-mysql-helper pcmt-mysqlinit-helper

    docker-compose -p pcmt -f "$composeFilePath"/docker-compose.yml up -d

    "$composeFilePath"/wait-http.sh "http://localhost:${DOCKER_PORT_HTTP}"
    docker-compose -p pcmt -f "$composeFilePath"/docker-compose.yml exec -T fpm console pim:user:create -n admin Admin123 admin@productcatalog.io admin admin en_US

elif [ "$1" == "up" ]; then
    docker-compose -p pcmt -f "$composeFilePath"/docker-compose.yml up -d
elif [ "$1" == "down" ]; then
    docker-compose -p pcmt -f "$composeFilePath"/docker-compose.yml stop
elif [ "$1" == "destroy" ]; then
    docker-compose -p pcmt -f "$composeFilePath"/docker-compose.yml down -v

    docker volume rm pcmt-traefik-data pcmt-fpm-data pcmt-mysql-data pcmt-mysqlinit-data
else
    echo "Valid options are: init, up, down, or destroy"
fi