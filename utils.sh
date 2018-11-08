#!/bin/bash
PROGRESS_BREAKS=$(( $(tput cols | grep -Po "(\d+)") - 25 ))

sleepT() {
  echo "Start time $(myDate)"
  total_duration=$(($1 * 60))
  # sleep $total_duration
  for a in `seq $total_duration`; do
    remaining=$(($total_duration - $a))
    current=$(($a * $PROGRESS_BREAKS / $total_duration))
    printf "\r$(bar $current $PROGRESS_BREAKS)($(pct $a $total_duration)%%) remaining $(toTime $remaining)s"
    sleep 1
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
  notify-send --icon="$(pwd)/icon.png","$(pwd)/icon2.png" -u critical "Pomodoro" "$@"
}

myPlay() {
  nohup play "$@" </dev/null >/dev/null 2>&1 &
}

myDate() {
  echo $(date +"%Y.%m.%d %H:%M:%S")
}