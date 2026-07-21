#!/bin/bash

appHome=@conf.app.home@
version=@version@
scriptDirectory="bin"
createImageFileName="createDockerImage.sh"
removeImageFileName="removeDockerImage.sh"
createZipFileName="createImageZip.sh"

APP_MODE_SYNTAX="Where App_Mode is: [ createImage | removeImage | createZip  ]"

validateAppMode() {
	if [ $1 = "createImage" -o $1 = "removeImage" -o $1 = "createZip" ]
	then
		return 0
	fi
	return 1
}

if [ $# -le 0 -o $# -gt 1 ]
then
	echo "Syntax Command: $0 App_Mode"
	echo "$APP_MODE_SYNTAX"
	exit 1
fi

validateAppMode $1

if [ $? = 0 ]
then
	case "$1" in
		createImage)
			$appHome/$version/$scriptDirectory/$createImageFileName $appHome
            RETVAL=$?
			;;
		createZip)
			$appHome/$version/$scriptDirectory/$createZipFileName $appHome
            RETVAL=$?
			;;
		removeImage)
			$appHome/$version/$scriptDirectory/$removeImageFileName
            RETVAL=$?
			;;
	 esac
	 exit $RETVAL
else
	echo "Syntax Command: $0 App_Mode"
	echo "$APP_MODE_SYNTAX"
	exit 1
fi