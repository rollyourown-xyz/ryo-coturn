#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
   echo "restore-module.sh: Use ansible to restore the persistent storage for a module"
   echo ""
   echo "Help: restore-module.sh"
   echo "Usage: ./restore-module.sh -n hostname -v version"
   echo "Flags:"
   echo -e "-n hostname \t\t(Mandatory) Name of the host on which to restore the module's persistent storage"
   echo -e "-s stamp \t\t(Mandatory) A stamp (e.g. date, time, name) to identify the backup to be restored"
   echo -e "-h \t\t\tPrint this help message"
   echo ""
   exit 1
}

errorMessage()
{
   echo "Invalid option or input variables are missing"
   echo "Use \"./backup-module.sh -h\" for help"
   exit 1
}

while getopts n:s:h flag
do
    case "${flag}" in
        n) hostname=${OPTARG};;
        s) stamp=${OPTARG};;
        h) helpMessage ;;
        ?) errorMessage ;;
    esac
done

if [ -z "$hostname" ] || [ -z "$stamp" ]
then
  errorMessage
fi

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/../configuration/configuration.yml)"


# Restore module container persistent storage
#############################################

echo ""
echo "Restoring "$MODULE_ID" container persistent storage on "$hostname" with stamp "$stamp""
ansible-playbook -i "$SCRIPT_DIR"/../../ryo-host/configuration/inventory_"$hostname" "$SCRIPT_DIR"/../backup-restore/restore-module.yml --extra-vars "module_id="$MODULE_ID" host_id="$hostname" backup_stamp="$stamp""
