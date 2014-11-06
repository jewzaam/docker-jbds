#!/bin/sh

# disable selinux
sudo setenforce 0

# setup xhost
xhost +si:localuser:$USER
