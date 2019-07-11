#!/bin/bash

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

cd "$scriptDir"
cd ../data/lock

for lockFile in *.lck; do

    workerInstanceName=${lockFile%*.lck}

    screenProc="$(screen -ls | grep ${workerInstanceName})"

    if [ ! -n "$screenProc" ] ; then
        rm -f "${lockFile}"
    fi

done

cd "$scriptDir"
cd ..

if [ ! -f "run_workers.sh" ] ; then
    echo "Missing Main Runner Script File!"
    exit
fi

./run_workers.sh > /dev/null

cd "$currDir"

exit
