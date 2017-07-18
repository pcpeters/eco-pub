#!/bin/bash

action="$2"
app_stack=${1/.*/}
app=${1/*./}

start(){

  service nginx start

}

stop(){

  service nginx stop

}

restart(){

  stop
  start

}

update(){

  apt-get install nginx -y

}

main (){

if [[ "$EUID" != 0 ]]; then
    echo "Error: run.sh must be executed as root."
    exit 1
  fi

  if [[ "${app_stack}" != "webservers" ]]; then
    echo "Error: the first argument must be 'webservers.<application>'"
    exit 1
  fi

  case "${app}" in
    "nginx")
      :
      ;;
    *)
      echo "Error: \"${app}\" is not a valid mlbserver application."
      exit 1
      ;;
  esac

  case "${action}" in
    "update"|"start"|"stop"|"restart")
      "${action}"
      ;;
    "-h"|"--help")
      exit 0
      ;;
    *)
      echo "Error: \""${action}"\" is not a valid argument."
      exit 1
      ;;
  esac

}

main $@
exit $?
