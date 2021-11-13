FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y upgrade -y \
    && apt-get clean

RUN apt-get install -y apt-utils \
    && apt-get install build-essentials \
        qemu-user-static \
        wget \
        curl \
        git \
        ubuntu-keyring \
        gnupg

ENV HOME /root
WORKDIR ${HOME}
RUN git clone https://github.com/RandomCoderOrg/fs-cook
WORKDIR ${HOME}/fs-cook

CMD ["/root/fs-cook/build-hirsute-raw.sh"]