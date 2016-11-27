
FROM fedora:25
MAINTAINER Eric Sage <eric.david.sage@gmail.com>

#Clean root
RUN rm /root/*

#Disable dnf deltas
RUN echo "deltarpm=0" >> /etc/dnf/dnf.conf

#Place config files
ADD /configfiles /root

#Add repositories
ADD repos /etc/yum.repos.d/

#Install base packages
RUN dnf clean all && dnf update -y
RUN dnf group install -y "Development Tools" "C Development Tools and Libraries"
RUN dnf install -y tmux vim elinks irssi rtorrent lynx mutt kernel-devel ctags git which man-pages man tree wget bind-utils whois python

#Install and update Python3 tools
RUN pip3 install --upgrade pip setuptools
RUN pip3 install virtualenv wheel

#Install SDKs and Cloud Management Tools
RUN dnf install -y docker-engine google-cloud-sdk kubectl && pip3 install awscli

#Install vim plugins
RUN vim -u NONE +'silent! source ~/.vimrc' +PlugInstall +qa

#Clean dnf cache
RUN dnf clean all

#Set the initial directory
WORKDIR /root/Code/src

#Set command to shell
CMD ["/bin/bash"]
