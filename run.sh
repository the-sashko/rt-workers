#!/bin/bash

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

cd "$scriptDir"
cd ..

while [ 1 ] ; do
    if [ "${1#--worker=}" != "$1" ] ; then
        workerName="${1#--worker=}"
    elif [ "${1#--scope=}" != "$1" ] ; then
        workerScope="${1#--scope=}"
    elif [ "${1#--count=}" != "$1" ] ; then
        workerCount="${1#--count=}"
    elif [ -z "$1" ] ; then
        break
    else
        echo "Unknown Input Key!" 1>&2
        exit 1
    fi
    shift
done

if [ ! -n "$workerName" ] ; then
    echo "Worker Name Does Not Set!"
    exit
fi

if [ ! -n "$workerScope" ] ; then
    workerScope='default_worker'
    exit
fi

if [ ! -n "$workerCount" ] ; then
    workerCount=1
    exit
fi

if [ ! -f "${workerName}_worker/run.sh" ] ; then
    echo "Invalid Script Name!"
    exit
fi

cd data/lock

for lockFile in *.lck; do

    lockFileID=${lockFile%*_worker.lck}

    lockFileID=${lockFileID:$(expr length "${workerScope}_${workerName}_")}

    lockFileID=$((lockFileID+1))

    if [[ $lockFileID -gt $workerCount ]] ; then
        rm -f "${lockFile}"
    fi

done

cd ../../scripts

workerID=0

while [[ $workerID -lt $workerCount ]]; do
    ./worker.sh --worker=${workerName} --id=${workerID} --scope=${workerScope} > /dev/null
    workerID=$((workerID+1))
done

cd "$currDir"

exit
