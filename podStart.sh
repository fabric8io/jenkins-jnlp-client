#!/usr/bin/env bash

# ***** IMPORTANT *****
# add lots of error handling.  If this script fails it's hard to know why the pods keeps restarting
# ***** IMPORTANT *****

if [ -d "/var/jenkins/.ssh-git" ]; then
	chmod 600 /var/jenkins/.ssh-git/ssh-key
	chmod 600 /var/jenkins/.ssh-git/ssh-key.pub
	chmod 700 /var/jenkins/.ssh-git
fi
if [ -d "/root/.gnupg" ]; then
	chmod 600 /root/.gnupg/pubring.gpg
	chmod 600 /root/.gnupg/secring.gpg
	chmod 600 /root/.gnupg/trustdb.gpg
	chmod 700 /root/.gnupg
fi

if [ "$DOCKER_REGISTRY_SERVER_ID" = "docker.io" ]; then
	docker login -u $DOCKER_REGISTRY_USERNAME -p $DOCKER_REGISTRY_PASSWORD -e fabric8-admin@googlegroups.com
fi
