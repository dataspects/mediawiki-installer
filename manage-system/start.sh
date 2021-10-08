#!/bin/bash
# Public MWMBashScript: Start MWM System.

source ../mediawiki-cli/my-system.env
source ./my-system.env
source ../mediawiki-cli/config-db/lib.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/utils.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/config-db/lib.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/logging/lib.sh

sudo $CONTAINER_COMMAND pod start $POD_NAME
sudo $CONTAINER_COMMAND container start $POD_NAME-mediawiki
sleep 5
compileMWMLocalSettings
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/waitForMariaDB.sh