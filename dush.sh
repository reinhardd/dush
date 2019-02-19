#!/bin/bash
#
# should be called from a project dir (i.e. head)
#
MOUNT=()
POSITIONAL=()
HOSTS=()
IMAGE=""
while [[ $# -gt 0 ]]
do
key="$1"
echo "parse $key"
case $key in
    -i|--image)
    IMAGE=("$2")
    shift
    shift
    ;;
    -m|--mount)
    MOUNT+=("$2")
    shift # past argument
    shift # past value
    ;;
    -h|--host)
    HOSTS+=("$2")
    shift
    shift
    ;;
    --)   # stop parsing 
    shift
    POSITIONAL+=("$*")
    break;
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

if [ "$IMAGE" = "" ]; then
  if [ -f .image ]; then
    IMAGE=$(head -n 1 .image)
  fi
  if [ "$IMAGE" = "" ]; then
    echo "no image"
    exit 1
  fi
  echo "use last image $IMAGE" 
else
    echo "$IMAGE" >.image
fi

set -- "${POSITIONAL[@]}" # restore positional parameters

echo "pos: ${POSITIONAL[@]} mnt: ${MOUNT[@]} host: ${HOSTS[@]}"


ADD_MOUNTS=""

for i in "${MOUNT[@]}"
do
   : 
   # echo "search for $i"
   ADD_MOUNTS="--volume=$i:$i $ADD_MOUNTS"
done


ADD_HOSTS=""
for i in "${HOSTS[@]}"
do
   : 
   echo "add host for $i"
   ADD_HOSTS="--add-host=$i $ADD_HOSTS"
done

DOCKERIMG=$USER/dush_$IMAGE
echo "img $DOCKERIMG"

docker images | grep $DOCKERIMG

if [ $? -ne 0 ]; then
    echo "no docker image for $USER -> look for create_dush.sh"
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
    ADD_HOSTS=""
    for i in ${HOSTLIST}
    do
        : 
        echo "add host for $i"
        ADD_HOSTS="--add-host=$i $ADD_HOSTS"
    done
fi

echo "ADD_HOSTS $ADD_HOSTS"

#
# MOUNTLIST=/path/to/dir1 /path/to/dir2
if [ -f mount.list ]; then
    echo "read mount.list"
    source mount.list
    if [ "$MOUNTLIST" != "" ]; then
      for MNT in $MOUNTLIST; do 
        echo "add mount $MNT"
        ADD_MOUNTS="--volume=$MNT:$MNT $ADD_MOUNTS"
      done
    fi
fi

echo "mounts $ADD_MOUNTS"

# echo "start docker --volume=$BR_CP:/home/build/$BR_INSIDE"
echo "$WORKDIR -- $DOCKERSCRIPT"


docker run $FLAGS  \
        --volume=$WORKDIR:$WORKDIR \
        $ADD_MOUNTS \
        $ADD_HOSTS \
        --rm $DOCKERIMG \
        dumb-init /bin/bash -c "(cd $WORKDIR && $DOCKERSCRIPT )"
#
# do not do anything here to preserve the return value from the command
