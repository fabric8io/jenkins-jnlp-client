#!/usr/bin/env bash

# ***** IMPORTANT *****
# add lots of error handling.  If this script fails it's hard to know why the pods keeps restarting
# ***** IMPORTANT *****

if [ -d "/home/jenkins/.ssh-git" ]; then
	chmod 600 /home/jenkins/.ssh-git/ssh-key
	chmod 600 /home/jenkins/.ssh-git/ssh-key.pub
	chmod 700 /home/jenkins/.ssh-git
fi
if [ -d "/home/jenkins/.gnupg" ]; then
	chmod 600 /home/jenkins/.gnupg/pubring.gpg
	chmod 600 /home/jenkins/.gnupg/secring.gpg
	chmod 600 /home/jenkins/.gnupg/trustdb.gpg
	chmod 700 /home/jenkins/.gnupg
fi

if [ "$DOCKER_REGISTRY_SERVER_ID" = "docker.io" ]; then
	docker login -u $DOCKER_REGISTRY_USERNAME -p $DOCKER_REGISTRY_PASSWORD -e fabric8-admin@googlegroups.com
fi

#Now start the jenkins slave
jenkins-slave $*
