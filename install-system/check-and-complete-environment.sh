#!/bin/bash
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110071930" ; fi

# Ensure CLI is ready
if [[ -d $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM ]]
then
    if [[ "$(ls -A $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM)" ]]
    then
        echo "$MEDIAWIKI_CLI_ON_HOSTING_SYSTEM ready"
    else
        echo "$MEDIAWIKI_CLI_ON_HOSTING_SYSTEM empty"
        exit
    fi
else
  echo "$MEDIAWIKI_CLI_ON_HOSTING_SYSTEM missing"; exit
fi

###

if ! podman_loc="$(type -p "sqlite3")" || [[ -z $podman_loc ]]; then
    echo "sqlite3 is missing. Install sqlite3 now?"
    promptToContinue
    sudo apt -y install sqlite3
fi

if ! podman_loc="$(type -p "podman")" || [[ -z $podman_loc ]]; then
    echo "$CONTAINER_COMMAND is missing. Install $CONTAINER_COMMAND now?"
    promptToContinue
    . /etc/os-release
    # Info: 18.04 is because $CONTAINER_COMMAND 3.1.0 rootless is faulty (Error processing tar file(exit status 1): operation not permitted)
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
    curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/Release.key | sudo apt-key add -
    sudo apt update
    sudo apt -y install podman
fi

if ! command -v jq &> /dev/null
then
    echo "jq is missing. Install jq now?"
    # promptToContinue
    sudo apt -y install jq
fi