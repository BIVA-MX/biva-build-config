#!/bin/bash

applicationName=@conf.app.name@
version=@version@

resultActiveContainer=$(docker ps -qf name=$applicationName)
resultStopContainer=$(docker ps -f name=$applicationName -f status=exited -q)
if [ ! -z "$resultActiveContainer" -o ! -z "$resultStopContainer" ];then
  echo ERROR: Existen contenedores activos actualmente $applicationName no se puede eliminar la imagen
  exit -1
fi

dockerContainerName="$applicationName:v$version"
result=$(docker images -f reference=$dockerContainerName)
if [ ! -z "$result" ];then
  echo Eliminando la imagen $dockerContainerName
  docker rmi $dockerContainerName
fi