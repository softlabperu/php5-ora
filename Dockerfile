FROM php:5.4-apache

RUN DEBIAN_FRONTEND="noninteractive" 
RUN apt update && apt install -y tzdata

RUN apt update && \
    apt install -y \
    vim \
    git \
    curl \
    alien \
    telnet

ADD oracle/*.rpm /

WORKDIR /

RUN alien -i oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient-devel-21.1.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient-sqlplus-21.1.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient-tools-21.3.0.0.0-1.x86_64.rpm && \
    echo "/usr/lib/oracle/21/client64/lib/" > /etc/ld.so.conf.d/oracle.conf && \
    ldconfig && \
    #ln -s /usr/bin/sqlplus64 /usr/bin/sqlplus && \
    rm -f /*.rpm

ENV DISPLAY=:99
