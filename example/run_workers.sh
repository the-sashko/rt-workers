#!/bin/bash

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

cd "$scriptDir"
cd "scripts"

./run.sh --worker=youtube --count=5 --scope=converter > /dev/null

cd "$currDir"

exit
