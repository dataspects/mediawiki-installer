#!/bin/bash
# Public MWMBashScript: Restart MWM System.

source $MEDIAWIKI_CLI/lib/utils.sh
source $MEDIAWIKI_CLI/lib/permissions.sh

source ./my-system.env

$MEDIAWIKI_CLI/manage-system/stop.sh
$MEDIAWIKI_CLI/manage-system/start.sh