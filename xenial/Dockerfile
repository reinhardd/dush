# Template for Debian-based OSes
FROM ubuntu:16.04

ARG BGID
ARG BUID
ARG USER
ARG HOME

MAINTAINER Reinhard Doerner, reinhard.doerner@gmail.com

RUN cat /etc/apt/sources.list

#RUN echo  "deb http://old-releases.ubuntu.com/ubuntu xenial main universe\n\
#deb http://old-releases.ubuntu.com/ubuntu xenial-updates main universe\n\
#deb http://old-releases.ubuntu.com/ubuntu xenial-security main universe\n" >/etc/apt/sources.list

#RUN cat /etc/apt/sources.list

RUN apt-get --help
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils ca-certificates curl
RUN curl -sLo /tmp/dumb-init.deb \
    https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb
	
RUN dpkg -i /tmp/dumb-init.deb
RUN rm /tmp/dumb-init.deb


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git-core build-essential subversion help2man diffstat \
        texi2html texinfo cvs gawk qemu unzip wget curl python \
        chrpath xz-utils debianutils iputils-ping \
        python3 python3-pip python3-pexpect \
        subversion nano g++-multilib sudo cpio

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

