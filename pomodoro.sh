#/bin/bash

# User settings
PAUSE_SOUND="1Up.mp3"
WORK_SOUND="work.mp3"
FIREBASE_USER="bruno"

# Script settings
PROGRESS_BREAKS=50
FIREBASE_URL="https://remote-pomodoro.firebaseio.com/"

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

sleepT() {
  total_duration=$(($1 * 60))
  # sleep $total_duration
  for a in `seq $total_duration`; do
    remaining=$(($total_duration - $a))
    current=$(($a * $PROGRESS_BREAKS / $total_duration))
    printf "\r$(bar $current $PROGRESS_BREAKS)($(pct $a $total_duration)%%) remaining $(toTime $remaining)s"
#    sleep 1
  done
  echo
}

bar() {
  result=""
  while [ ${#result} -lt $2 ]; do
    if [ ${#result} -lt $1 ]; then
      result="$result#"
    else
      result="$result "
    fi
  done
  echo "[$result]"
}

pct() {
  echo $(($1 * 100 / $2))
}

toTime() {
  echo "$(($1 / 60 )):$(($1 % 60))"
}

notify(){
  notify-send -i "$(pwd)/icon.png" -u critical "Pomodoro" "$@"
}

myPlay() {
  nohup play "$@" </dev/null >/dev/null 2>&1 &
}

main $@
