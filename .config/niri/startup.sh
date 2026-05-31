#!/bin/bash
exec > /tmp/startup.log 2>&1
set -x

sleep 1

# Left column
ghostty --title="yazi" -e yazi &
sleep 1

ghostty --title="fastfetch" &
sleep 1

niri msg action set-window-width "50%"
niri msg action  move-column-left
niri msg action set-window-height "66.667%"
niri msg action consume-window-into-column

# Right column
ghostty --title="btop" -e btop &
sleep 1

ghostty --title="music" -e subtui &
sleep 1

niri msg action set-window-width "50%"
niri msg action move-column-left
niri msg action consume-window-into-column
# niri msg action set-window-height "33.333%"
niri msg action focus-column-left-or-last
