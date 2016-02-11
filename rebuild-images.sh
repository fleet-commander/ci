#!/bin/bash

ARGS="--no-cache=true --force-rm=true"

ARGS=""

function usage {
    echo "Usage: $COMMAND FEDORA_RELEASE [--help] [DOCKER_OPTIONS]"
}

function help {
    usage
    echo -e "\t--help: Shows this help"
}

if [[ $* == *--help* ]]; then
    help
    exit 1
fi

if [ -z $1 ]; then
    usage
    exit 1
fi

COMMAND=$0
DIST=$1


if [ $2 ]; then
    shift
    ARGS=$*
fi

DISTS=`ls data/`

if [[ $DISTS == *$DIST* ]]; then
    docker build -f data/$DIST/Dockerfile.base -t fc-base:$DIST $ARGS .
    if [ $? != 0 ]; then
        echo "Error building base image"
        exit 1
    fi

    docker build -f data/$DIST/Dockerfile.build -t fc-build:$DIST $ARGS .
    if [ $? != 0 ]; then
        echo "Error building build image"
        exit 1
    fi

    docker build -f data/$DIST/Dockerfile.admin -t fc-admin:$DIST $ARGS .
    if [ $? != 0 ]; then
        echo "Error building admin image"
        exit 1
    fi
else
    echo "Specified target distribution is not valid. "
fi