#!/bin/bash

if [ -z $1 ]
then
	echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
	exit
fi

APP_HOME=$1

applicationName=@conf.app.name@
version=@version@

docker save $applicationName:v$version -o $APP_HOME/$applicationName-$version.zip
