#!/bin/bash
# Public MWMBashScript: Install system from scratch.

# source ../mediawiki-cli/config-db/lib.sh
# source ../mediawiki-cli/lib/permissions.sh
# # These are obtained from command parameters:
# set -a
#   source $ENVmwins
#   source $ENVmwcli
# set +a

# if [ -n "$DEBUG" ] ; then echo "RUN LEX2110071929" ; fi

# source ./install-system/check-and-complete-environment.sh
# source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/config-db/lib.sh
# source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/logging/lib.sh
# source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/utils.sh
# source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/permissions.sh

# # initializeSystemLog
# if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080709" ; fi
# $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/initialize-mwcliconfigdb.sh

# mkdir --parent \
#   $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/extensions \
#   $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/skins \
#   $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/vendor \
#   $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/images \
#   $SYSTEM_SNAPSHOT_FOLDER_ON_HOSTING_SYSTEM \
#   $CURRENT_RESOURCES_ON_HOSTING_SYSTEM \
#   $MARIADB_FOLDER_ON_HOSTING_SYSTEM
# writeToSystemLog "Initialized hostPath folders"

# ### >>>
# # MWM Concept: initialize persistent mediawiki service volumes
# echo $DEBUG
# if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080710" ; fi
# source ./install-system/initialize-persistent-mediawiki-service-volumes.sh
# # <<<

# if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080711" ; fi
# touch $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/mwmLocalSettings.php
# echo "{}" > $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/composer.local.json
# echo "{}" > $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/composer.local.lock





# echo $SYSTEM_SNAPSHOT_FOLDER_ON_HOSTING_SYSTEM
# if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080712" ; fi
# envsubst < mediawiki-deployment-local.tpl > mediawiki-deployment.yml

# $CONTAINER_COMMAND pod stop $POD_NAME
# $CONTAINER_COMMAND pod rm $POD_NAME

# if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080713" ; fi

docker-compose up -d

# setPermissionsOnSystemInstanceRoot

# initializemwmLocalSettings
$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c \
"php $MEDIAWIKI_CLI_IN_CONTAINER/lib/addToMWMSQLite.php \"ls\" \"
\\\$wgServer = 'https://$SYSTEM_DOMAIN_NAME:4443';
\\\$wgDBpassword = '$WG_DB_PASSWORD';
\\\$wgDBserver = '$MYSQL_HOST';
\""



compileMWMLocalSettings

setPermissionsOnSystemInstanceRoot

source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/waitForMariaDB.sh

echo "Create database and user..."
$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u root -p$MARIADB_ROOT_PASSWORD \
  -e \" CREATE DATABASE $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$WG_DB_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%';
        FLUSH PRIVILEGES;\""

echo "Import database..."
$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c \
  "mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  mediawiki < $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/db.sql"

runMWUpdatePHP

##########
# RESTIC #
##########

echo "Initialize restic backup repository"
$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c \
  "restic --password-file $RESTIC_PASSWORD_IN_CONTAINER --verbose init --repo $SYSTEM_SNAPSHOT_FOLDER_IN_CONTAINER"