# Ansible managed: /workspace/users/albandri10/env/ansible/roles/jenkins-slave/templates/Dockerfile.j2 modified on 2014-09-24 18:00:17 by albandri on albandri-laptop-misys
#FROM        stackbrew/ubuntu:14.04
FROM        jasongiedymin/ansible-base-ubuntu
#FROM        debian:jessie

VOLUME      ["/var/log/jenkins"]

MAINTAINER  Alban Andrieu "https://github.com/AlbanAndrieu/nabla"

ENV			DEBIAN_FRONTEND noninteractive
#ENV         JENKINS_HOME /jenkins

# Working dir
ENV WORKDIR /tmp/build/ansible-jenkins-slave

# ADD
ADD default $WORKDIR/default
ADD meta $WORKDIR/meta
ADD files $WORKDIR/files
ADD handlers $WORKDIR/handlers
ADD tasks $WORKDIR/tasks
ADD templates $WORKDIR/templates
ADD vars $WORKDIR/vars
ADD docker $WORKDIR/docker

# Here we continue to use add because
# there are a limited number of RUNs
# allowed.
ADD docker/hosts /etc/ansible/hosts
ADD docker/playbook.yml $WORKDIR/playbook.yml

# Execute
RUN         ansible-playbook $WORKDIR/playbook.yml -c local

#RUN         apt-get update && \
#            apt-get install -y openssh-server openjdk-7-jre-headless
#RUN         useradd -m -s /bin/bash jenkins
#RUN         echo jenkins:jenkins | chpasswd
#RUN         mkdir -p /var/run/sshd
            
EXPOSE      22
ENTRYPOINT  ["/etc/init.d/jenkins-swarm-client"]
#ENTRYPOINT ["java", "-jar", "/jenkins/swarm-client-1.9-jar-with-dependencies.jar"]
CMD /usr/sbin/sshd -D
#CMD ["-g", "deamon off;"]
