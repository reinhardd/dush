#!/bin/bash
#
# should be called from a project dir (i.e. head)
#

DOCKERIMG=$USER/dush_$UID

docker images | grep $DOCKERIMG

if [ $? -ne 0 ]; then
    echo "no docker image for $USER -> look for create_docker_shell.sh"
    exit 2
fi

if [ $# -eq 0 ]
then
  echo "need a command for docker"
  exit 1
fi

DOCKERSCRIPT=$*

FLAGS="-ti"

WORKDIR=$PWD

#
# hosts.list:
# HOSTLIST="--add-host=svn-server:10.100.250.15 ... "
#
#        --add-host=svn-server:10.100.250.15 \
#        --add-host=svn-server.local:10.100.250.15 \
#        --add-host=cvs-server:10.100.250.15 \
#        --add-host=cvs-server.local:10.100.250.15 \
#        --add-host=gitlab.krauth-eb.local:10.100.250.203 \
if [ -f hosts.list ]; then
    source hosts.list
fi

# echo "start docker --volume=$BR_CP:/home/build/$BR_INSIDE"

docker run $FLAGS  \
        --volume=$WORKDIR:$WORKDIR \
        $HOSTLIST \
        --rm $DOCKERIMG \
        dumb-init /bin/bash -c "(cd $WORKDIR && $DOCKERSCRIPT )"
#
# do not do anything here to preserve the return value from the command
