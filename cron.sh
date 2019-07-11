#!/bin/bash

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

cd "$scriptDir"

./start.sh > /dev/null

cd "$currDir"

exit
