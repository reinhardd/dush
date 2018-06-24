#!/bin/bash

if [ $UID -eq 0 ]; then
    echo "do not run as root"
    exit 3
fi

base=$1
# echo "base $base"

if [ "$base" = "" ]; then
    echo "no base image defined"
    exit 4
fi

if [ ! -d $base ]; then
  if [ ! -d /usr/share/dush/$base ]; then
    echo "unable to find Dockerfile directory $base"
    exit 5
  else
    base=/usr/share/dush/$base
  fi
fi

groupid=`id -g`

if [ "$groupid" = "" ]; then
    echo "invalid setup: unable to retrieve groupip"
    exit 2
fi

if [ "$UID" = "" ]; then
    echo "invalid setup: unable to retrieve userid"
    exit 1
fi

TAGNAME=$USER/dush_$base_$UID
echo "create docker image $TAGNAME"
 
docker ps -a | grep $TAGNAME
if [ $? -eq 0 ]; then
    echo "warning: $TAGNAME already exists"
fi

echo "build for $HOME $UID $groupid"

docker build --build-arg BGID=$groupid --build-arg BUID=$UID --build-arg USER=$USER --build-arg HOME=$HOME -t $TAGNAME ${base}
