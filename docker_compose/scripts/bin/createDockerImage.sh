#!/bin/bash

if [ -z $1 ]
then
	echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
	exit
fi

APP_HOME=$1

applicationName=@conf.app.name@
version=@version@
dockerFolder="docker"

echo Creando la imagen Docker $applicationName:v$version

cd $APP_HOME/$version/$dockerFolder

docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t $applicationName:v$version .