#!/bin/bash

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

cd "$scriptDir"
cd ..

while [ 1 ] ; do
    if [ "${1#--worker=}" != "$1" ] ; then
        workerName="${1#--worker=}"
    elif [ "${1#--id=}" != "$1" ] ; then
        workerID="${1#--id=}"
    elif [ "${1#--scope=}" != "$1" ] ; then
        workerScope="${1#--scope=}"
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
    echo "Worker Scope Does Not Set!"
    exit
fi

if [ ! -n "$workerID" ] ; then
    echo "Worker ID Does Not Set!"
    exit
fi

if [ -f "data/lock/${workerScope}_${workerName}_${workerID}_worker.lck" ] ; then
    echo "Script Already Runnig!"
    exit
fi

if [ ! -f "${workerName}_worker/run.sh" ] ; then
    echo "Invalid Script Name!"
    exit
fi

date +%s > "data/lock/${workerScope}_${workerName}_${workerID}_worker.lck"

screenProc="$(screen -ls | grep ${workerScope}_${workerName}_${workerID}_worker)"
screenProc=${screenProc%%.*}

if [ -n "$screenProc" ] ; then
	kill -9 "${screenProc}"
fi

screen -wipe

nice -n 19 screen -dmS "${workerScope}_${workerName}_${workerID}_worker" ./scripts/loop.sh --worker=${workerName} --id=${workerID} --scope=${workerScope} > /dev/null

cd "$currDir"

exit
