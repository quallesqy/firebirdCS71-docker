FROM ubuntu
MAINTAINER Rishandi <shandy@semuada.com>

ENV FIREBIRD_PATH=/opt/firebird
ENV FIREBIRD_DB_PASSWORD=masterkey
ENV FIREBIRD_DB_PASSWORD_DEFAULT=masterkey

RUN apt-get update
RUN apt-get install wget -y
RUN apt-get install libstdc++5 -y
RUN apt-get install xinetd -y
RUN apt-get install vim -y
RUN wget http://sourceforge.net/projects/firebird/files/firebird-linux-amd64/2.1.7-Release/FirebirdCS-2.1.7.18553-0.amd64.tar.gz
RUN tar -vzxf FirebirdCS-2.1.7.18553-0.amd64.tar.gz
RUN rm FirebirdCS-2.1.7.18553-0.amd64.tar.gz
RUN rm FirebirdCS-2.1.7.18553-0.amd64/install.sh
RUN rm FirebirdCS-2.1.7.18553-0.amd64/scripts/postinstall.sh

COPY install.sh FirebirdCS-2.1.7.18553-0.amd64
COPY postinstall.sh FirebirdCS-2.1.7.18553-0.amd64/scripts

RUN cd FirebirdCS-2.1.7.18553-0.amd64 && ./install.sh ${FIREBIRD_DB_PASSWORD_DEFAULT}
RUN rm -r FirebirdCS-2.1.7.18553-0.amd64

COPY firebird.conf ${FIREBIRD_PATH} 
COPY fbudflib2.so ${FIREBIRD_PATH}/UDF
COPY build.sh ${FIREBIRD_PATH}

RUN cd ${FIREBIRD_PATH} && mkdir DBA && chown firebird:firebird DBA && chmod -R 770 DBA
RUN cd / && mkdir dba && chown firebird:firebird dba && chmod -R 770 dba

COPY firebird.conf ${FIREBIRD_PATH} 
COPY security2.fdb ${FIREBIRD_PATH}
RUN cd ${FIREBIRD_PATH} && chown firebird:firebird firebird.conf && chmod -R 777 firebird.conf
RUN cd ${FIREBIRD_PATH} && chown firebird:firebird security2.fdb && chmod -R 777 security2.fdb

EXPOSE 3050/tcp
EXPOSE 3051/tcp
EXPOSE 3052/tcp

WORKDIR ${FIREBIRD_PATH}
ENTRYPOINT ${FIREBIRD_PATH}/build.sh 
