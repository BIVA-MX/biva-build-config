#!/bin/sh

if [ -z $1 ]
then
	echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
	exit
fi

APP_HOME=$1
DATE=`date +%Y%m%d%H%M%S`

applicationName=@conf.app.name@
maxLogFiles=@conf.script.cleanLog.maxLogFiles@
version=@version@
scriptDirectory=bin
setEnvFileName=setEnv.sh

. $APP_HOME/$version/$scriptDirectory/$setEnvFileName

validateResult="true"
validateLogPath() {
	if [ -z "$(ls -A $LOG_DIRECTORY/*.log*)" ]
	then
		echo "[ERROR]: No se logro limpiar los logs."
		echo "El $LOG_DIRECTORY directorio no contiene archivos logs"
		validateResult="false"
		validatePathResult="false"
	else
		echo "[INFO]: Se limpiaron los logs"
	fi
}

validateInputPath() {
	if [ -z "$(ls -A $INPUT_DIRECTORY/*.bin*)" ] || [ -z "$(ls -A $INPUT_DIRECTORY/*.bin*)" ]
	then
		echo "[ERROR]: No se logro limpiar el directorio input."
		echo "El $INPUT_DIRECTORY directorio no contiene archivos"
		validateResult="false"
		validatePathResult="false"
	else
		echo "[INFO]: Se limpiaron los archivos del directorio input"
	fi
}

manageDirectory() {
	validatePathResult="true"
	$2
	if [ $validatePathResult = "true" ]
	then
		cd $1
		tarName="$applicationName-"$DATE"-"$version.tgz
		tar --exclude='*.tgz' -zcvf $tarName . --warning=no-file-changed
		find $1 -mindepth 1 -mtime $maxLogFiles -delete
		find . -type f ! -name '*.tgz' -delete
		find . -type d ! -name '*.tgz' -delete
	fi
}

echo "Cleaning logs..."
result=$(docker ps -f status=running -f name=$applicationName -q)
if [ ! -z $result ]
then
	echo "[ERROR]: No se pueden limpiar actualmente los archivos logs por que la aplicacion esta en ejecucion"
	exit -1
fi

manageDirectory $LOG_DIRECTORY "validateLogPath"

if [ ! -z "$INPUT_DIRECTORY" ]
then
	manageDirectory $INPUT_DIRECTORY "validateInputPath"
fi

cd $APP_HOME
if [ $validateResult = "true" ]
then
	exit 0
else
	exit -1
fi