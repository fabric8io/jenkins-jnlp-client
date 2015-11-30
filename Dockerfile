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
     apt-get install -y docker

RUN mkdir -p /root/.m2/
COPY mvnsettings.xml /root/.m2/settings.xml
COPY ssh-config /root/.ssh/config

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV JENKINS_HOME /var/jenkins_home

COPY podStart.sh /usr/local/bin/podStart.sh

WORKDIR /var/jenkins_home

ENTRYPOINT ["/usr/local/bin/podStart.sh"]
