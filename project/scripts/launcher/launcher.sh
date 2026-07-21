#!/bin/sh

appHome=@conf.app.home@
version=@version@
scriptDirectory=bin
startFileName="start.sh"
cleanLogsFileName="cleanLogs.sh"
shutdownFileName="shutdown.sh"
statusFileName="status.sh"
setEnvFileName="setEnv.sh"

APP_MODE_SYNTAX="Where App_Mode is: [start | startClean | stop | stopClean | status | clean  ]"

#Private functions
validateAppMode() {
	if [ $1 = "start" -o $1 = "startClean" -o $1 = "stop" -o $1 = "stopClean" -o $1 = "status" -o $1 = "clean" ]
	then
		return 0
	fi
	return 1
}

#Shell Body
if [ $# -le 0 ]
then
	echo "Syntax Command: $0 App_Mode"
	echo "$APP_MODE_SYNTAX"
	exit 1
fi

validateAppMode $1

if [ $? = 0 ]
then
	case "$1" in
		start)
			$appHome/$version/$scriptDirectory/$startFileName $appHome $@
			RETVAL=$?
			echo "**** Return code = $RETVAL"
			;;
		startClean)
			$appHome/$version/$scriptDirectory/$cleanLogsFileName $appHome
			$appHome/$version/$scriptDirectory/$startFileName $appHome $@
			RETVAL=$?
			echo "**** Return code = $RETVAL"
		    ;;
		stop)
			$appHome/$version/$scriptDirectory/$shutdownFileName $appHome
			RETVAL=$?
			echo "**** Return code = $RETVAL"
			;;
		stopClean)
			$appHome/$version/$scriptDirectory/$shutdownFileName $appHome
			$appHome/$version/$scriptDirectory/$cleanLogsFileName $appHome
			RETVAL=$?
			echo "**** Return code = $RETVAL"
			;;
		status)
			$appHome/$version/$scriptDirectory/$statusFileName $appHome
			RETVAL=$?
			;;
        clean)
            $appHome/$version/$scriptDirectory/$cleanLogsFileName $appHome
            RETVAL=$?
            ;;
	 esac
	 exit $RETVAL
else
	echo "Syntax Command: $0 App_Mode"
	echo "$APP_MODE_SYNTAX"
	exit 1
fi