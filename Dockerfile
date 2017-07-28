FROM debian:latest as fetch
MAINTAINER OpusVL <dev@opusvl.com>

RUN apt-get update && apt-get install -y curl bzip2
RUN curl https://cpan.metacpan.org/authors/id/S/SH/SHAY/perl-5.20.3.tar.bz2 | tar -jx

FROM debian:latest as build
COPY --from=fetch /perl-5.20.3 /perl-5.20.3

RUN apt-get update && apt-get -y install build-essential

WORKDIR /perl-5.20.3

RUN ./Configure -des -Dprefix=/opt/perl-5.20.3
RUN make -j $(nproc)

FROM debian:latest as test
COPY --from=build /perl-5.20.3 /perl-5.20.3

RUN apt-get update && apt-get -y install build-essential procps

WORKDIR /perl-5.20.3

RUN make test -j $(nproc)

FROM debian:latest as install
COPY --from=build /perl-5.20.3 /perl-5.20.3

RUN apt-get update && apt-get -y install build-essential

WORKDIR /perl-5.20.3

RUN make install -j $(nproc)

FROM debian:latest as release
COPY --from=install /opt/perl-5.20.3 /opt/perl-5.20.3
RUN ln -s /opt/perl-5.20.3 /opt/perl5

FROM debian:latest AS dev
COPY --from=release /opt/perl-5.20.3 /opt/perl-5.20.3
RUN ln -s /opt/perl-5.20.3 /opt/perl5

RUN apt-get update && apt-get install -y build-essential

ENV PERL_MM_USE_DEFAULT 1
RUN /opt/perl5/bin/cpan App::cpanminus
