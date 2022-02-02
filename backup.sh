#!/bin/bash

# backup.sh
# This script backs up the persistent storage for a module


# Help and error messages
#########################

helpMessage()
{
  echo "backup.sh: Back up the persistent storage for a module"
  echo "Usage: ./backup.sh -n hostname -v version"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host from which to back up module container persistent storage"
  echo -e "-s stamp \t\t(Mandatory) A stamp (e.g. date, time, name) to identify the backup"
  echo -e "-h \t\t\tPrint this help message"
  echo ""
  exit 1
}

errorMessage()
{
  echo "Invalid option or input variables are missing"
  echo "Use \"./backup.sh -h\" for help"
  exit 1
}


# Command-line input handling
#############################

restore="false"

while getopts n:s:rh flag
do
  case "${flag}" in
    n) hostname=${OPTARG};;
    s) stamp=${OPTARG};;
    h) helpMessage ;;
    ?) errorMessage ;;
  esac
done

if [ -z "$hostname" ] || [ -z "$stamp" ]; then
  errorMessage
fi


# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/configuration/configuration.yml)"

echo "Starting backup of "$MODULE_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-module/stop-module-containers.sh -n "$hostname"
/bin/bash "$SCRIPT_DIR"/scripts-module/backup-module.sh -n "$hostname" -s "$stamp"
/bin/bash "$SCRIPT_DIR"/scripts-module/start-module-containers.sh -n "$hostname"
echo "Backup completed"
