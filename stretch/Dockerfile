# Template for Debian-based OSes
FROM debian:stretch


ARG BGID
ARG BUID
ARG USER

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
    && curl -sLo /tmp/dumb-init.deb \
		https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64.deb \
	&& dpkg -i /tmp/dumb-init.deb \
	&& rm /tmp/dumb-init.deb

# yocto sumo Essentials
RUN  apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping

# yocto sumo Graphical and Eclipse Plug-In Extras
#RUN  apt-get -y install libsdl1.2-dev xterm

# yocto sumo Documentation
#RUN  apt-get -y install xsltproc docbook-utils fop dblatex xmlto

# yocto sumo OpenEmbedded Self-Test
#RUN  apt-get -y install python-git

RUN apt-get -y install locales

RUN dpkg-reconfigure locales

RUN apt-get clean

RUN rm /root/.bashrc

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# create a group/user
RUN groupadd --gid $BGID $USER

# create a non-root user
RUN useradd --home-dir $HOME -s /bin/bash \
        --uid $BUID --gid $BGID --groups sudo \
        $USER

RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8#

# RUN locale-gen en_US.UTF-8
# RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8


WORKDIR /home/$USER

# give users in the sudo group sudo access in the container
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER
