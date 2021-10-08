#!/bin/bash

mkdir mediawiki-cli
mkdir mediawiki-installer

sudo sshfs -o allow_other lex@10.0.2.2:/home/lex/mediawiki-cli /home/dserver/mediawiki-cli
sudo sshfs -o allow_other lex@10.0.2.2:/home/lex/mediawiki-installer /home/dserver/mediawiki-installer

cd mediawiki-installer
ENVmwins=my-system.env \
ENVmwcli=../mediawiki-cli/my-system.env \
        ./install-system/install-system-Ubuntu-20.04.sh