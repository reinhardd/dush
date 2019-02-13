
FROM debian:jessie


ARG BGID
ARG BUID
ARG USER
ARG HOME

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
    && curl -sLo /tmp/dumb-init.deb \
		https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb \
	&& dpkg -i /tmp/dumb-init.deb \
	&& rm /tmp/dumb-init.deb

# yocto sumo Essentials
RUN  apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping

# special essenentials for chromium engine and aris repos
RUN apt-get -y install locales subversion nano g++-multilib sudo

RUN apt-get -y install apt-utils ninja-build
#
# find.pl was removed from perl for security reasons.
# krogoth build for openssl needs it anyway.
# the copied variant emulates its behaviour using the File Module.
#
# COPY find.pl /etc/perl


# locale 
RUN echo "en_US.UTF-8 UTF-8" >/etc/locale.gen
RUN locale-gen 
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN echo "LANGUAGE=en_US:en" >> /etc/default/locale
RUN echo ": \"${LANG:=en_EN.utf8}\"; export LANG" >>/etc/profile
RUN apt-get clean

RUN rm /root/.bashrc

# create a group/user
RUN groupadd --gid $BGID $USER

# create a non-root user
RUN echo "$HOME -- $BUID -- $BGID -- $USER"
RUN useradd --home-dir $HOME -s /bin/bash --uid $BUID --gid $BGID --groups sudo $USER

WORKDIR /home/$USER

RUN echo "LANG=en_US.UTF-8" >/home/$USER/.bash_profile
RUN echo "export LANG" >>/home/$USER/.bash_profile
RUN echo "LANG=en_US.UTF-8" >/home/$USER/.bashrc
RUN echo "export LANG" >>/home/$USER/.bashrc
RUN chown $USER:$USER /home/$USER/.bash_profile
RUN chown $USER:$USER /home/$USER/.bashrc

# give users in the sudo group sudo access in the container
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

