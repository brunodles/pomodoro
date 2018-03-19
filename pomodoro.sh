#/bin/bash
BREAKS=50
PAUSE_SOUND="1Up.mp3"
WORK_SOUND="work.mp3"

main() {
  echo "">nohup.out
  case $1 in
    short|s)
      echo "Short break"
      changeLeds '{"gpio0": 0, "gpio2": 1}'
      sleepT 5
      play $WORK_SOUND
      notify "Back to work"
      ;;
    long|l)
      echo "Long break"
      changeLeds '{"gpio0": 0, "gpio2": 1}'
      sleepT 10
      play $WORK_SOUND
      notify "Back to work"
    ;;
    work|w)
      echo "Pomodoro"
      changeLeds '{"gpio0": 1, "gpio2": 0}'
      sleepT 25
      play $PAUSE_SOUND
      notify "Make a break"
    ;;
    setup)
      sudo apt-get install sox
      sudo apt-get install sox libsox-fmt-all
    ;;
    test)
      echo "Test"
      play $WORK_SOUND
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

changeLeds() {
  # nohup curl -s --request PUT \
    curl -s --request PATCH \
  --url "https://esp-ci.firebaseio.com/gpio.json" \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --data "$@"
  # --data $@ &>/dev/null &
}

changeLed() {
  nohup curl -s --request PUT \
  --url "https://esp-ci.firebaseio.com/gpio/gpio$1.json" \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --data $2 &>/dev/null &
}

sleepT() {
  total_duration=$(($1 * 60))
  # sleep $total_duration
  for a in `seq $total_duration`; do
    remaining=$(($total_duration - $a))
    current=$(($a * $BREAKS / $total_duration))
    printf "\r$(bar $current $BREAKS)($(pct $a $total_duration)%%) remaining $(toTime $remaining)s"
    sleep 1
  done
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

play() {
  nohup play "$@" &>/dev/null &
}

main $@
