#!/bin/sh

export processName=@conf.app.name@

echo '############################################################'
echo "Initializing $processName..."
echo '############################################################'

if [ -z $1 ]
then
	echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
	exit
fi

APP_HOME=$1

logName=@conf.app.logName@
scriptDirectory="bin"
checkLogFileName="checkLog.sh"
setEnvFileName="setEnv.sh"
explodedJar=@conf.spring.explodedJar@
springConfigPath=@conf.spring.configPath@
shutdownFileName="shutdown.sh"
version=@version@
jarName=@archivesBaseName@

PATH_EXPLODED_JAR=$APP_HOME/$version/$explodedJar
PATH_CONFIG=$PATH_EXPLODED_JAR/$springConfigPath
JAR_NAME=$PATH_EXPLODED_JAR/$jarName-${version}.jar

. $APP_HOME/$version/$scriptDirectory/$setEnvFileName

# script body.
PID=`ps -fea | grep $processName | grep -v grep | awk '{print $2}'`

if [ ! -z $PID ]
then
	echo "[ERROR]: El aplicativo esta ejecutandose actualmente"
	echo "con el siguiente ID de Proceso: $PID"
	exit -1
fi

foundProperty () {
	paramProperty="$(grep -e $1 $PROPERTIES_FILE)"
	param="$(echo $paramProperty | sed 's/.*://')"
}

getMemParam() {
	foundProperty "mem"

	if [ -z "$param" ]
	then
		echo "[ERROR] No se encontro el parametro mem en el archivo $PROPERTIES_FILE"
		echo "Es necesario establecer la memoria para arrancar el aplicativo"
		exit -1
	fi
	memParams=$param
}

getMemParam

cd $PATH_EXPLODED_JAR

echo "$LOG_DIRECTORY/$logName.log"
additionalArgs=""
if [ $# -ge 3 ]; then
	additionalArgs="${@:3}"
fi
$JAVA_HOME/bin/java $additionalArgs $JVM_EXTRA_ARGS -DprocessName=$processName -jar $JAR_NAME $memParams --spring.config.location=$PROPERTIES_FILE --config.path=$PATH_CONFIG --process.id=$processName > $LOG_DIRECTORY/$logName.log 2>&1 &

$APP_HOME/$version/$scriptDirectory/$checkLogFileName $LOG_DIRECTORY/$logName.log $APP_HOME

RETVAL=$?

if [ $RETVAL -eq 0 ]
then
	#checkLog
        PID=`ps -fea | grep $processName | grep -v grep | awk '{print $2}'`
        echo "$processName is up and running. PID = [$PID]."
        exit 0
else
	$APP_HOME/$version/$scriptDirectory/$shutdownFileName $APP_HOME
	exit -1
fi