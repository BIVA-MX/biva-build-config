#!/bin/bash

applicationName=@conf.app.name@

echo Deteniendo contenedor $applicationName

result=$(docker ps -f status=running -q)
if [ -z "$result" ]; then
  echo El contenedor $applicationName no esta en ejecución.
  exit -1
fi

docker stop $(docker ps -q --filter name=$applicationName)