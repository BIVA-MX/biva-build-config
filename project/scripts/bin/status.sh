#!/bin/bash

if [ -z $1 ]
then
	echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
	exit 1
fi

APP_HOME=$1

logName=@conf.app.logName@
processName=@conf.app.name@
endWord=@conf.script.shutdown.endWord@
scriptDirectory="bin"
setEnvFileName="setEnv.sh"
version=@version@

. $APP_HOME/$version/$scriptDirectory/$setEnvFileName

checkApplicationUp() {
	PID=`ps -fea | grep $processName | grep -v grep | awk '{print $2}'`
	if [ -z "$PID" ] || [ $PID == "" ]; then
		echo "[INFO] La aplicacion $processName \"NO\" esta en ejecucion"
		checkStopProcess
		return $?
	fi
	echo "[INFO] La aplicacion $processName se encuentra en ejecucion con el PID [$PID]"
	return 0
}

checkStopProcess() {
	if [ ! -f $LOG_DIRECTORY/$logName.log ]; then
		echo "[WARN] No se encontro el archivo $LOG_DIRECTORY/$logName.log para encontrar"
		echo "[WARN] la correcta baja del proceso"
      	return 1;
    fi

    STATUS=`cat ${LOG_DIRECTORY}/$logName.log | grep "$endWord"`
    if [ -z "$STATUS" ]; then
    	echo "[WARN] No se encontro la palabra $endWord en el archivo $LOG_DIRECTORY/$logName.log"
    	echo "[WARN] para determinar que el aplicativo tuvo una baja correcta"
    	echo "[WARN] Se muestra las 10 ultimas lineas del archivo"
    	tail -10 $LOG_DIRECTORY/$logName.log
    	return 1;
	fi
    return 1;
}

checkApplicationUp
echo "ExitCode=$?"
exit $?