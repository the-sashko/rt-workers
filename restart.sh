#!/bin/bash

RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'

currDir=$(pwd)
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

cd "$scriptDir"

printf "${YELLOW}Stopping All Workers${WHITE}...${RED}"

./stop.sh > /dev/null

printf "${GREEN}OK!${NC}\n"

printf "${YELLOW}Starting All Workers${WHITE}...${RED}"

./start.sh > /dev/null

printf "${GREEN}OK!${NC}\n"

cd "$currDir"

exit
