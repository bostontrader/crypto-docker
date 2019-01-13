#!/bin/sh

# The GUI needs /etc/machine-id set and this sets it.
systemd-machine-id-setup

# If you try this for display :0 it may not work.
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &

