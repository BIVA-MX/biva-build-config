#!/bin/bash

applicationName=@conf.app.name@
version=@version@

result=$(docker ps -qf name=$applicationName)
if [ ! -z "$result" ];then
  echo Deteniendo el contenedor $applicationName
  docker stop $(docker ps -q --filter name=$applicationName)
fi

result=$(docker ps -f name=$applicationName -f status=exited -q)
if [ ! -z "$result" ];then
  echo Eliminando el contenedor $applicationName
  docker rm $(docker ps -aq --filter name=$applicationName)
fi

dockerContainerName="$applicationName:v$version"
result=$(docker images -f reference=$dockerContainerName)
if [ ! -z "$result" ];then
  echo Eliminando la imagen $dockerContainerName
  docker rmi $dockerContainerName
fi