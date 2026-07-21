#!/bin/bash

applicationName=@conf.app.name@

if [ ! -z "$1" ];
then
    applicationName=$applicationName-$1
fi

echo Creando el contenedor Docker $applicationName

@conf.docker.containerCommand@ --name $applicationName @conf.app.name@:v@version@
