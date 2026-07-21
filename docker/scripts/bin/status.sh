#!/bin/bash

applicationName=@conf.app.name@

result=$(docker ps -f name=$applicationName -q)
if [ -z "$result" ];then
  echo El contenedor $applicationName no se esta ejecutando.
else
  echo El contenedor $applicationName se esta ejecutando.
fi