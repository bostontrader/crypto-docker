#!/bin/sh

export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
x11vnc -display :1 &

freicoin-qt -datadir=/.freicoin &

