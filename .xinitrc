#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export EDITOR="vim"
#export BROWSER="google-chrome"
export BROWSER="firefox"

export LC_CTYPE="zh_CN.UTF-8"
export XMODIFIERS="@im=fcitx"
export XIM=fcitx
export XIM_PROGRAM=fcitx
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"


export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

export VDPAU_NVIDIA_NO_OVERLAY=1 

xset s 0
xset dpms 0 0 0
#compton  --unredir-if-possible --backend glx  --vsync opengl --config ~/.compton.conf -b
#nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUCurrentFanSpeed=90"
numlockx on &
setxkbmap -option ctrl:nocaps &
exec  awesome
