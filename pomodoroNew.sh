#!/bin/bash
source ./utils.sh
DOC=""

# User settings
PAUSE_SOUND="1Up.mp3"
WORK_SOUND="work.mp3"
FIREBASE_USER="bruno"

# Vars
title=""
message=""
duration=0
sound=""

# send message
start() {
  echo $title
  sleepT $duration
  myPlay $sound
  notify "$message"
}

DOC+="
  work
    - start work
"
work() {
  title="Pomodoro"
  duration=25
  sound=$PAUSE_SOUND
  message="Make a break"
  start
}

DOC+="
  short
    - start a short break
"
short() {
    title="Short break"
    duration=5
    sound=$WORK_SOUND
    message="Back to work"
    start
}

DOC+="
  long
    - start a long break
"
long() {
  title="Long break"
  duration=10
  sound=$WORK_SOUND
  message="Back to work"
  start
}

DOC+="
  setup
    - install necessary tools
"
setup() {
  sudo apt-get install sox
  sudo apt-get install sox libsox-fmt-all
}

help() {
cat <<TEXT
Pomodoro

 Usage:
$0 <command>

 Commands:
$DOC
TEXT
}

if [ "$(type -t $1)" == "function" ]; then
  $@
else
  help
fi
