#!/usr/bin/env bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /usr/local/share/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

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
if [ -d "/home/jenkins/.ssh" ]; then
        chmod 600 /home/jenkins/.ssh/config
        chmod 700 /home/jenkins/.ssh
        cp -r /home/jenkins/.ssh /root/
fi

#Now start the jenkins slave
if [[ $# -eq 1 ]]; then

	# if `docker run` only has one arguments, we assume user is running alternate command like `bash` to inspect the image
	exec "$@"

else

	# if -tunnel is not provided try env vars
	if [[ "$@" != *"-tunnel "* ]]; then
		if [[ ! -z "$JENKINS_TUNNEL" ]]; then
			TUNNEL="-tunnel $JENKINS_TUNNEL"
		fi
	fi

	if [[ ! -z "$JENKINS_URL" ]]; then
		URL="-url $JENKINS_URL"
	fi

	exec java $JAVA_OPTS -cp /usr/share/jenkins/slave.jar hudson.remoting.jnlp.Main -headless $TUNNEL $URL "$@"
fi

