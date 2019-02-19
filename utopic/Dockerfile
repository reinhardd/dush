# Template for Debian-based OSes
FROM ubuntu:14.10

ARG BGID
ARG BUID
ARG USER
ARG HOME

MAINTAINER Reinhard Doerner, reinhard.doerner@gmail.com

RUN cat /etc/apt/sources.list

RUN echo  "deb http://old-releases.ubuntu.com/ubuntu utopic main universe\n\
deb http://old-releases.ubuntu.com/ubuntu utopic-updates main universe\n\
deb http://old-releases.ubuntu.com/ubuntu utopic-security main universe\n" >/etc/apt/sources.list

RUN cat /etc/apt/sources.list

COPY dumb-init_1.1.0_amd64.deb /tmp/dumb-init.deb

RUN apt-get --help
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN apt-get install -y curl
RUN dpkg -i /tmp/dumb-init.deb
RUN rm /tmp/dumb-init.deb


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git-core build-essential subversion help2man diffstat texi2html texinfo cvs gawk qemu unzip wget

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y chrpath

RUN (echo "dash dash/sh boolean false"|debconf-set-selections;dpkg-reconfigure --frontend noninteractive dash)

RUN rm /root/.bashrc

# create a group/user
RUN groupadd --gid $BGID $USER

# create a non-root user
RUN echo "$HOME -- $BUID -- $BGID -- $USER"
RUN useradd --home-dir $HOME -s /bin/bash \
        --uid $BUID --gid $BGID --groups sudo \
        $USER

WORKDIR /home/$USER

# give users in the sudo group sudo access in the container
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

