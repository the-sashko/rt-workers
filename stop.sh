#!/bin/bash

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

cd "$scriptDir"
cd ../data/lock

for lockFile in *.lck; do

    workerInstanceName=${lockFile%*.lck}

    screenProc="$(screen -ls | grep ${workerInstanceName})"
    screenProc=${screenProc%%.*}

    if [ -n "$screenProc" ] ; then
        kill -9 "${screenProc}"
    fi

    rm -f "$lockFile"
done

screen -wipe

cd "$currDir"

exit
