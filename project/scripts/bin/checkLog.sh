#!/bin/bash

if [ -z $1 ] || [ -z $2 ]; then
	echo "No se puede ejecutar correctamente la aplicacion"
	exit -1
fi

logFile=$1
APP_HOME=$2

STOP_PARAM="stop"
successWord="@conf.script.checkLog.successWord@"
errorWord="@conf.script.checkLog.errorWord@"
endWord=@conf.script.shutdown.endWord@
timeToSleep=@conf.script.checkLog.timeToSleep@
attemptsNumber=@conf.script.checkLog.attemptsNumber@	

checkFilePhrase(){
	foundChar=$( grep -w "$2" $1 )
	isExistChar  $foundChar
}	


isExistChar(){
	if [ -z $1 ]; 
		then
		RETVAL=0
	else
		RETVAL=1
	fi
}


#Script body
times=0
while [ "$times" -lt "$attemptsNumber" ]; do	
	checkFilePhrase $logFile $endWord
	if [ $RETVAL -eq 1 ]; 
		then 
		echo "Se detecto una baja del proceso ..."
		tail -10 $logFile
		exit -1	
	else	
		checkFilePhrase $logFile "$errorWord"
		if [ $RETVAL -eq 1 ]; 
				then 
					echo "Se detecto un error ... "
					echo $logFile
					tail -10 $logFile
					exit -1
		else
			checkFilePhrase $logFile "$successWord"
			if [ $RETVAL -eq 1 ]; 
				then
					exit 0;
			else
				times=`echo "$times + 1" | bc`
				echo "esperando $timeToSleep segundos, para el intento $times"
				sleep $timeToSleep
			fi
		fi
	fi
done	

echo "Se sobrepaso el numero limite de intentos:.  $times"
tail -10 $logFile
sh $APP_HOME/launcher.sh $STOP_PARAM
exit -1