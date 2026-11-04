#!/bin/bash

applicationName=@conf.app.name@
APP_HOME=$1
version=@version@
scriptDirectory=bin
createDockerContainerFileName=createDockerContainer.sh

containersNumber=$(docker ps -a --filter name=$applicationName --format "{{.Names}}" | wc -l)

if [ $containersNumber -lt 1 ];
then
    echo "Se debe crear un contenedor para poder crear una instancia del mismo"
    exit -1
else
  instanceNumber=$(( containersNumber + 1 ))
  $APP_HOME/$version/$scriptDirectory/$createDockerContainerFileName $instanceNumber
  RETVAL=$?
  if [ ! $RETVAL -eq 0 ]; then
    echo Se genero un error al crear el contenedor Docker
    exit $RETVAL
  fi
fi