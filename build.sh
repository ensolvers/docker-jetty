#!/bin/bash

TAG=$1

if [[ -z $TAG ]]; then
  TAG="latest"
fi

docker build -t ensolvers/jetty:1.1 .
