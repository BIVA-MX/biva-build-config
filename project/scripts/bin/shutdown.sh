#!/bin/bash

if [ -z $1 ]
then
    echo "[ERROR]: Los parametros para ejecutar este script son incorrectos"
    return 1
fi

APP_HOME=$1

processName=@conf.app.name@
logName=@conf.app.logName@
scriptDirectory="bin"
setEnvFileName="setEnv.sh"
endWord=@conf.script.shutdown.endWord@
version=@version@

. $APP_HOME/$version/$scriptDirectory/$setEnvFileName

KILLED=0

echo "Deteniendo proceso $processName"

PID=`ps -fea | grep $processName | grep -v grep | awk '{print $2}'`
if [ -z "$PID" ]
then
        echo "El proceso con nombre [$processName] no fue encontrado."
        exit -1
fi

echo "$processName $endWord" >> $LOG_DIRECTORY/$logName.log
echo "Finalizando proceso con ID: [$PID]"
kill -9 $PID > /dev/null 2>&1

PID_TMP=`ps -fea | grep $processName | grep -v grep | awk '{print $2}'`
ATTEMPTS=0
MAX_ATTEMPTS=10
while [ "$PID_TMP" ==  "$PID" ]
do
    sleep 1
    PID_TMP=`ps -fea | grep $processName | grep -v grep | awk '{print $2}'`
    ATTEMPTS=$(( $ATTEMPTS + 1 ))
    echo "ESPERANDO $ATTEMPTS SEGUNDO"
    if [ $ATTEMPTS -gt $MAX_ATTEMPTS ]
    then
        kill -9 $PID > /dev/null 2>&1
        echo "MORE TIME THAN EXPECTED kill -9 $PID" >> $LOG_DIRECTORY/$logName.out
        PID_TMP='-10000'
    fi
done

KILLED=$?
exit $KILLED