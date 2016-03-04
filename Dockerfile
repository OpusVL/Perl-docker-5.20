FROM debian:wheezy
MAINTAINER Colin Newell <colin@opusvl.com>
USER root
RUN apt-get update && apt-get install -y build-essential libexpat1-dev libpq-dev \
            libxml2-dev psmisc unzip less libjpeg8-dev libpng12-dev curl wget &&\
    apt-get dist-upgrade -y
RUN mkdir /opt/perl-5.14.4 && \
    mkdir /opt/perl-5.14.4/bin && \
    mkdir /opt/perl-5.14.4/lib && \
    mkdir /opt/perl-5.14.4/man
RUN ln -s /opt/perl-5.14.4 /opt/perl5
WORKDIR /root
RUN wget https://cpan.metacpan.org/authors/id/D/DA/DAPM/perl-5.14.4.tar.bz2 &&\
    tar -jxf perl-5.14.4.tar.bz2 && rm perl-5.14.4.tar.bz2 &&\
    cd /root/perl-5.14.4 && ./Configure -des -Dprefix=/opt/perl-5.14.4 && \
    make && make test && make install && rm -rf /root/perl-5.14.4
RUN cd /root; curl -L https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm | /opt/perl5/bin/perl - --self-upgrade
