#!/bin/bash

if [ -z $1 ]
then
	echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
	exit
fi

APP_HOME=$1

applicationName=@conf.app.name@
version=@version@
scriptDirectory=bin
createDockerImageFileName=createDockerImage.sh
createDockerContainerFileName=createDockerContainer.sh

dockerContainerName="$applicationName:v$version"
echo Buscando la imagen Docker con nombre: $dockerContainerName

result=$(docker images -f reference=$dockerContainerName -q)
if [ -z "$result" ]; then
  $APP_HOME/$version/$scriptDirectory/$createDockerImageFileName $APP_HOME
  RETVAL=$?
  if [ ! $RETVAL -eq 0 ]; then
    echo Se genero un error al crear la imagen Docker
    exit $RETVAL
  fi
fi

result=$(docker ps -af name=$applicationName -q)
if [ -z "$result" ]; then
  $APP_HOME/$version/$scriptDirectory/$createDockerContainerFileName
  RETVAL=$?
  if [ ! $RETVAL -eq 0 ]; then
    echo Se genero un error al crear el contenedor Docker
    exit $RETVAL
  fi
fi

result=$(docker ps -f status=running -f name=$applicationName -q)
if [ -z "$result" ]; then
  echo Se inicializa el contenedor $applicationName
  docker start $(docker ps -aq --filter name=$applicationName)
  RETVAL=$?
  if [ ! $RETVAL -eq 0 ]; then
    echo Se genero un error al correr el contenedor $applicationName
    exit $RETVAL
  fi
else
  echo El contenedor $applicationName ya se esta ejecutando
fi