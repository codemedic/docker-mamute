#!/bin/bash

case "$1" in
    bash|/bin/bash)
        command=/bin/bash;
        mode=shell
        ;;
    run)
        if [ -z "${MAMUTE_INSTALL_DIR}" ]; then
            echo MAMUTE_INSTALL_DIR not defined.;
            exit 1;
        fi;
        command="${MAMUTE_INSTALL_DIR}/run.sh";
        mode=run
        ;;
    *)
        echo "Unknown command '$1'";
        exit 1;
        ;;
esac
shift;

if [[ "$mode" == run ]]; then

    : ${MYSQL_SERVER:=mysql}
    : ${MYSQL_USER:=mamute}
    : ${MYSQL_DATABASE:=mamute}

    if [ -z "$MYSQL_PASSWORD" ]; then
        echo MYSQL_PASSWORD not specified.;
        exit 1;
    fi

    echo "Using MySQL details:";
    echo "    Host: ${MYSQL_SERVER}";
    echo "    User: ${MYSQL_USER}";
    echo "    Database: ${MYSQL_DATABASE}";

    jvm_opts=("-server");

    # mysql opts
    jvm_opts+=("-Dhibernate.mysql_host=${MYSQL_SERVER}");
    jvm_opts+=("-Dhibernate.mysql_database=${MYSQL_DATABASE}");
    jvm_opts+=("-Dhibernate.mysql_username=${MYSQL_USER}");
    jvm_opts+=("-Dhibernate.mysql_password=${MYSQL_PASSWORD}");

    export MAMUTE_OPTS="${jvm_opts[@]}"
fi

exec $command "$@";
