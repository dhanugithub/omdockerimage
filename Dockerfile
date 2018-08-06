#s2i-java

FROM openshift/base-centos7
MAINTAINER Dhanashree Kulkarni <kulkarnidhana22@gmail.com

#HOME in base image is /opt/app-root/src

#Install build tools on top of base image
#Java jdk 8, Maven 3.3

RUN INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && yum install -y --enablerepo=centosplus $INSTALL_PKGS && rpm -V $INSTALL_PKGS && yum clean all -y && mkdir -p /opt/openshift && mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ENV MAVEN_VERSION 3.3.9
RUN (curl -0 http://www.eu.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven && ln -sf /usr/local/maven/bin/mvn /usr/local/bin/mvn && mkdir -p $HOME/.m2 && chmod -R a+rwX $HOME/.m2

ENV PATH=/opt/maven/bin/:$PATH
ENV BUILDER_VERSION 1.0
LABEL io.k8s.description="Platform for building Java (fatjar) applications with maven or gradle" io.k8s.display-name="Java S2I builder 1.0" io.openshift.expose-services="8080:http" io.openshift.tags="builder,maven-3,gradle-2.6,java,microservices,fatjar"

COPY ./contrib/settings.xml $HOME/.m2/


LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY ./sti/bin/ /usr/local/sti


RUN chown -R 1001:1001 /opt/openshift
USER 1001

EXPOSE 8080

CMD ["usage"]
