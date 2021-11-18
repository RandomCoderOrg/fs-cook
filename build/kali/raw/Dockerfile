FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND noninteractive

ENV DISABLE_LOCAL_DEBOOTSTRAP true

RUN apt update; apt upgrade -y ;apt install -y build-essential \
        qemu-user-static \
        wget \
        curl \
        git \
        gnupg \
        binfmt-support \
        debootstrap

ENV HOME /root
WORKDIR ${HOME}
RUN git clone https://github.com/RandomCoderOrg/fs-cook
WORKDIR ${HOME}/fs-cook

CMD ["/root/fs-cook/build-kali-raw.sh"]