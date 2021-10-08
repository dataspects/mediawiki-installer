#!/bin/bash
# Public MWMBashScript: Stop MWM System.

source ./my-system.env

sudo $CONTAINER_COMMAND pod stop $POD_NAME

if [[ $? == 0 ]]
then
    printf "\x1b[32mSUCCESS\033[0m: stopped pod $POD_NAME\n"
else
    printf "Pod $POD_NAME not found, so not stopped. Continuing...\n"
fi