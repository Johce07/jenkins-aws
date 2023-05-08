#!/bin/bash

paquetes=("apache2" "git" "mysql" "php" "mariadb-server")

for p in "${paquetes[@]}"
do
    if dpkg -s "$p" >/dev/null 2>&1; then
        echo "$p está instalado"
    else
        echo "$p no está instalado"
    fi
done
