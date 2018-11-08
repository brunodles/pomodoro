#!/bin/bash
source ./utils.sh

# User settings
PAUSE_SOUND="1Up.mp3"
WORK_SOUND="work.mp3"
FIREBASE_USER="bruno"

# Script settings
PROGRESS_BREAKS=50
FIREBASE_URL="https://remote-pomodoro.firebaseio.com/"


short() {
    echo "Short break"
    remoteState '{"id":"s", "type": "break", "duration": 5, "name": "Short break" }'
    sleepT 5
    myPlay $WORK_SOUND
    notify "Back to work"
}

long() {
  echo "Long break"
  remoteState '{"id":"l", "type": "break", "duration": 10, "name": "Long break" }'
  sleepT 10
  myPlay $WORK_SOUND
  notify "Back to work"
}

work() {
  echo "Pomodoro"
  sleepT 25
  remoteState '{"id":"w", "type": "work", "duration": 25, "name": "Pomodoro" }'
  myPlay $PAUSE_SOUND
  notify "Make a break"
}

main() {
  echo "">nohup.out
  case $1 in
    short|s)
      echo "Short break"
      remoteState '{"id":"s", "type": "break", "duration": 5, "name": "Short break" }'
      sleepT 5
      myPlay $WORK_SOUND
      notify "Back to work"
      ;;
    long|l)
      echo "Long break"
      remoteState '{"id":"l", "type": "break", "duration": 10, "name": "Long break" }'
      sleepT 10
      myPlay $WORK_SOUND
      notify "Back to work"
    ;;
    work|w)
      echo "Pomodoro"
      sleepT 25
      remoteState '{"id":"w", "type": "work", "duration": 25, "name": "Pomodoro" }'
      myPlay $PAUSE_SOUND
      notify "Make a break"
    ;;
    setup)
      sudo apt-get install sox
      sudo apt-get install sox libsox-fmt-all
    ;;
    test)
      echo "Test"
      myPlay $WORK_SOUND
      notify "Is it working"
    ;;
    *)
      cat <<-HELP
Pomodoro

Usage
$0 <command>

Available Commands

  short		make a short break, 5 minutes
  long		make a long break, 10 minutes
  work		work, 25 minutes
  setup		install tools
  test		show test notification

Samples:
$0 work
$0 short

HELP
    ;;
  esac
}

remoteState() {
#  auth=$(curl ${FIREBASE_URL}/)
  curl -s --request PUT \
  --url ${FIREBASE_URL}/${FIREBASE_USER}/state.json \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --data "$@" > /dev/null
}

main $@
