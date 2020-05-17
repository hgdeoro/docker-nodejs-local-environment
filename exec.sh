#!/usr/bin/env bash

set -e
set -u

MAKEFILE_DIRECTORY=$(cd $(dirname $0); pwd)
CURRENT_DIRECTORY=$(pwd)

make --quiet -C ${MAKEFILE_DIRECTORY} \
    WORKDIR=${CURRENT_DIRECTORY} \
    COMMAND_AND_ARGS="$*" \
    run
