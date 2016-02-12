#!/bin/bash
# Copyright (C) 2016 Red Hat, Inc.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the licence, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, see <http://www.gnu.org/licenses/>.
#
# Author: Oliver Gutiérrez <ogutierrez@redhat.com>

if [ $UID != 0 ]; then
    echo "You must have root privileges to execute this script"
    exit 1
fi

ARGS="--no-cache=true --rm=true"
ARGS=""

COMMAND=$0

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