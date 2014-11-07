FROM fedora:20
MAINTAINER Naveen Malik <jewzaam@gmail.com>
RUN yum update -y && yum clean all
RUN yum install -y xorg-x11-server-Xvfb \
xorg-x11-twm tigervnc-server \
xterm xorg-x11-font \
xulrunner-26.0-2.fc20.x86_64 \
dejavu-sans-fonts \
dejavu-serif-fonts \
xdotool xorg-x11-apps && yum clean all

