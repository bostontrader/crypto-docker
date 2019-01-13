#!/bin/sh

export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
joulecoin-qt -datadir=/.joulecoin &
x11vnc -display :1 &
