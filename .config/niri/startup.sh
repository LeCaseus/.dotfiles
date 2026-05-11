#!/bin/bash
exec > /tmp/startup.log 2>&1
set -x

sleep 5

# Left column
ghostty --title="files" -e yazi &
sleep 1

ghostty --title="fetch" &
sleep 1

niri msg action  move-column-left
niri msg action consume-window-into-column

# Right column
ghostty --title="monitor" -e btop &
sleep 1
ghostty --title="matrix" -e cmatrix &
sleep 1
niri msg action move-column-left
niri msg action consume-window-into-column
niri msg action set-window-height "33.333%"
niri msg action focus-column-left-or-last
