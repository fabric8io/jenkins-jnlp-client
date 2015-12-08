FROM java:8-jdk

ENV HOME /home/jenkins
ENV JENKINS_HOME /home/jenkins
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN useradd -c "Jenkins user" -d $HOME -m jenkins

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

# Install Docker prerequisites
RUN apt-get update -qq && apt-get install -qqy \
	apt-transport-https \
	apparmor \
	ca-certificates \
	supervisor \
	curl

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh && \
     apt-get update && \
     apt-get install -y --force-yes docker-engine=1.8.0-0~jessie

RUN cd /usr/local && \
    wget https://github.com/github/hub/releases/download/v2.2.2/hub-linux-amd64-2.2.2.tgz && \
    tar xf /usr/local/hub-linux-amd64-2.2.2.tgz && \
    rm /usr/local/hub-linux-amd64-2.2.2.tgz && \
    ln -s /usr/local/hub-linux-amd64-2.2.2/hub /usr/bin/hub

RUN mkdir -p /home/jenkins/.m2/
COPY mvnsettings.xml /home/jenkins/.m2/settings.xml

RUN mkdir -p /home/jenkins/.ssh && touch /home/jenkins/.ssh/known_hosts && ssh-keyscan -t rsa github.com >> /home/jenkins/.ssh/known_hosts
COPY ssh-config /home/jenkins/.ssh/config

COPY start.sh /usr/local/bin/start.sh
WORKDIR /home/jenkins

#Link ssh maven and gpg to root
RUN ln -sf /home/jenkins/.ssh /root/.ssh && ln -sf /home/jenkins/.m2 /root/.m2 && ln -sf /home/jenkins/.gnupg /root/.gnupg

ENTRYPOINT ["/usr/local/bin/start.sh"]
