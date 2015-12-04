FROM jenkinsci/jnlp-slave:latest

USER root
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
    wget https://github.com/github/hub/releases/download/v2.2.1/hub-linux-amd64-2.2.1.tar.gz && \
    tar xf /usr/local/hub-linux-amd64-2.2.1.tar.gz && \
    rm /usr/local/hub-linux-amd64-2.2.1.tar.gz && \
    ln -s /usr/local/hub-linux-amd64-2.2.1/hub /usr/bin/hub

RUN mkdir -p /root/.m2/
COPY mvnsettings.xml /root/.m2/settings.xml
COPY ssh-config /root/.ssh/config

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV JENKINS_HOME /var/jenkins

COPY start.sh /usr/local/bin/start.sh

WORKDIR /var/jenkins

ENTRYPOINT ["/usr/local/bin/start.sh"]
