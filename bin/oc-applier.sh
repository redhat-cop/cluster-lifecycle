#!/bin/bash

function do_policy() {
  echo "Applying Cluster Policy Objects..."
  success=1
  retries=0
  while [ $retries -lt 5 ] && [ $success -ne 0 ]; do
    output=$(oc apply -f $DIRECTORY 2>&1)
    success=$?
    retries=$[$retries+1]
  done
  echo "$output"
  echo "Done with Cluster Policy."
}

function do_namespaces() {
  echo "Applying Namespaces..."
  oc apply -f ./namespaces
  echo "Done with Namepsaces."
}

function do_deploy() {
  echo "Applying Deployments..."
  for app in $(find $DIRECTORY -maxdepth 1 -mindepth 1 -type d -exec basename {} \;);
  do
          for dir in $(find ${DIRECTORY}/${app} -maxdepth 1 -mindepth 1 -type d -exec basename {} \;);
          do
            oc process -f ${DIRECTORY}/${app}/${app}-template.yml --param-file=${DIRECTORY}/${app}/${dir}/params | oc apply -f -
          done
  done

  echo "Done with Deployments."
}

function do_build() {
  echo "Applying Builds..."   
  for app in $(find $DIRECTORY -maxdepth 1 -mindepth 1 -type d -exec basename {} \;);
  do
	  for dir in $(find ${DIRECTORY}/${app} -maxdepth 1 -mindepth 1 -type d -exec basename {} \;);
	  do
	    oc process -f ${DIRECTORY}/${app}/${app}-template.yml --param-file=${DIRECTORY}/${app}/${dir}/params | oc apply -f -
          done
  done
  echo "Done with Builds."
}


# Process input
for i in "$@"
do
  case $i in
    --all)
      ACTION="all"
      DIRECTORY="deploy"
      shift;;
    --action=*)
      ACTION="${i#*=}"
      DIRECTORY="${i#*=}"
      shift;;
    --help)
      usage
      exit 0;;
    *)
      echo "Invalid Option: ${i%=*}"
      exit 1;
      ;;
  esac
done

command -v oc help >/dev/null 2>&1 || { echo >&2 "OpenShift Command Line Tool is required!"; exit 1; }

if [ -z "${DIRECTORY+xxx}" ] || [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory \"$DIRECTORY\" does not exist!"
  exit 1
fi



actions="policy namespaces build deploy"

if [[ $actions =~ (^| )$ACTION($| ) ]]; then
  do_$ACTION
elif [[ "$ACTION" == "all" ]]; then
  for action in $actions; do
    do_$action
  done
else
  echo "Invalid value for --action: $ACTION"
  echo "Valid actions: $actions"
  exit 1
fi
