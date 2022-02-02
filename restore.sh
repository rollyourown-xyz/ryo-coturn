#!/bin/bash

# restore.sh
# This script redeploys a module and restores a previous backup of the persistent storage for the module
# This should only be used if necessary, e.g. after a system failure or failed upgrade.
#
# ATTENTION!!!
# The process will **delete** the current persistent storage for the module and replace it with the content
# of a backup. This will return the module to a previous state, which will affect any projects that
# depend on the module
# THIS SHOULD NORMALLY ONLY BE DONE TOGETHER WITH A PROJECT RESTORE FOR DISASTER RECOVERY - e.g. AFTER A SYSTEM FAILURE

# restore.sh
# This script restores the persistent storage for a module


# Help and error messages
#########################

helpMessage()
{
  echo "restore.sh: Restore a previous backup of the persistent storage for a module"
  echo "Usage: ./restore.sh -n hostname -s stamp"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host from which to restore module container persistent storage"
  echo -e "-s stamp \t\t(Mandatory) A stamp (e.g. date, time, name) to identify the backup to restore to the host server"
  echo -e "-h \t\t\tPrint this help message"
  echo ""
  exit 1
}

errorMessage()
{
  echo "Invalid option or input variables are missing"
  echo "Use \"./restore.sh -h\" for help"
  exit 1
}


# Command-line input handling
#############################

restore="false"

while getopts n:s:h flag
do
  case "${flag}" in
    n) hostname=${OPTARG};;
    s) stamp=${OPTARG};;
    h) helpMessage ;;
    ?) errorMessage ;;
  esac
done

if [ -z "$hostname" ]|| [ -z "$stamp" ]; then
  errorMessage
fi

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/configuration/configuration.yml)"


# Warn the user and get confirmation
####################################

echo " "
echo "!!! CAUTION! "
echo "!!! "
echo "!!! A restore should normally only be carried out after a system failure, a failed upgrade"
echo "!!! or to move projects and modules to a new host server. "
echo " "
echo "!!! A restore should not be carried out for a host server with functioning"
echo "!!! projects! "
echo " "
echo "Do you want to restore a backup for "$MODULE_ID" on "$hostname"? (y/n)"
echo "Default is 'n'."
echo -n "Restore backup? "
read -e -p "[y/n]:" RESTORE_BACKUP
RESTORE_BACKUP="${RESTORE_BACKUP:-"n"}"
RESTORE_BACKUP="${RESTORE_BACKUP,,}"

if [ ! "$RESTORE_BACKUP" == "y" ] && [ ! "$RESTORE_BACKUP" == "n" ]; then
  echo "Invalid option "${RESTORE_BACKUP}". Exiting"
  exit 1

elif [ "$RESTORE_BACKUP" == "n" ]; then
  echo "Exiting"
  exit 1

else
  echo ""
  echo "!!! ARE YOU SURE? "
  echo "!!! "
  echo "!!! If your module and the projects depending on it are currently working,"
  echo "!!! you will lose the current state and may not be able to recover it! "
  echo "!!! "
  echo "!!! If you proceed, you will restore the module "$MODULE_ID" "
  echo "!!! on "$hostname" from backups stamped with "$stamp" "
  echo "!!! "
  echo "!!! Please confirm by typing 'yes' for the next question "
  echo "!!! Default is 'no'."
  echo ""
  echo -n "Are you sure that you want to restore a backup? "
  read -e -p "[yes/no]:" RESTORE_BACKUP_SURE
  RESTORE_BACKUP_SURE="${RESTORE_BACKUP_SURE:-"no"}"
  RESTORE_BACKUP_SURE="${RESTORE_BACKUP_SURE,,}"
  
  if [ ! "$RESTORE_BACKUP_SURE" == "yes" ] && [ ! "$RESTORE_BACKUP_SURE" == "no" ]; then
    echo "Invalid option "${RESTORE_BACKUP_SURE}". Exiting"
    exit 1

  elif [ "$RESTORE_BACKUP_SURE" == "no" ]; then
    echo "Exiting"
    exit 1
  
  else
    echo ""
    echo "!!! Please confirm the stamp of the backup to restore "
    echo "!!! " 
    echo "!!! You will be restoring from backups with stamp: "$stamp" "
    echo "!!! "
    echo "!!! Please confirm by typing 'yes' for the next question "
    echo "!!! Default is 'no'."
    echo ""
    echo -n "Are you sure that the backup stamp is correct? "
    read -e -p "[yes/no]:" RESTORE_BACKUP_STAMP_SURE
    RESTORE_BACKUP_STAMP_SURE="${RESTORE_BACKUP_STAMP_SURE:-"no"}"
    RESTORE_BACKUP_STAMP_SURE="${RESTORE_BACKUP_STAMP_SURE,,}"
    
    if [ ! "$RESTORE_BACKUP_STAMP_SURE" == "yes" ] && [ ! "$RESTORE_BACKUP_STAMP_SURE" == "no" ]; then
      echo "Invalid option "${RESTORE_BACKUP_STAMP_SURE}". Exiting"
      exit 1

    elif [ "$RESTORE_BACKUP_STAMP_SURE" == "no" ]; then
      echo "Exiting"
      exit 1

    fi
  fi
fi

echo "Starting restore of "$MODULE_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-module/stop-module-containers.sh -n "$hostname"
/bin/bash "$SCRIPT_DIR"/scripts-module/restore-module.sh -n "$hostname" -s "$stamp"
/bin/bash "$SCRIPT_DIR"/scripts-module/start-module-containers.sh -n "$hostname"
echo "Restore completed"
