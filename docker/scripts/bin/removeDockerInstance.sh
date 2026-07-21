#!/bin/bash

applicationName=@conf.app.name@
containersNumber=$(docker ps -a --filter name=$applicationName --format "{{.Names}}" | wc -l)

if [ $containersNumber -lt 2 ];
then
    echo "No existe instancias creadas desde el contenedor principal"
    exit -1
else
    docker stop $applicationName-$containersNumber
    docker rm $applicationName-$containersNumber
fi