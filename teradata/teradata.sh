set -e
db-health() {
  # validate the db is up
  if ! pdestate -a | grep "PDE state is RUN/STARTED."; then
    return 1
  fi
  if ! pdestate -a | grep "DBS state is 5: Logons are enabled - The system is quiescent"; then
    return 1
  fi
}
wait-until-health() {
  counter=0
  while true; do
    # if db-health; then
    #   break
    # else
    #   ((counter++))
    #   sleep 1
    #   echo ${counter} times retry
    # fi
    pdestate -a
  done
}
$@
