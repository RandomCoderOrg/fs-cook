FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND noninteractive

ENV DISABLE_LOCAL_DEBOOTSTRAP true

RUN apt-get update; apt-get upgrade -y ;apt-get install -y build-essential \
        qemu-user-static \
        wget \
        curl \
        git \
        gnupg \
        binfmt-support \
        debootstrap
RUN apt-get clean

ENV HOME /root
WORKDIR ${HOME}
RUN git clone https://github.com/RandomCoderOrg/fs-cook
WORKDIR ${HOME}/fs-cook

CMD ["/root/fs-cook/build-kali-raw.sh"]