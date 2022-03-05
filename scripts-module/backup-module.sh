#!/bin/bash

# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
   echo "backup-module.sh: Use ansible to back up the persistent storage for the module"
   echo ""
   echo "Help: backup-module.sh"
   echo "Usage: ./backup-module.sh -n hostname -v version"
   echo "Flags:"
   echo -e "-n hostname \t\t(Mandatory) Name of the host on which to back up the module"
   echo -e "-s stamp \t\t(Mandatory) A stamp (e.g. date, time, name) to identify the backup"
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


# Back up module container persistent storage
#############################################

echo ""
echo "Backing up "$MODULE_ID" container persistent storage on "$hostname" with stamp "$stamp""
ansible-playbook -i "$SCRIPT_DIR"/../../ryo-host/configuration/inventory_"$hostname" "$SCRIPT_DIR"/../backup-restore/backup-module.yml --extra-vars "module_id="$MODULE_ID" host_id="$hostname" backup_stamp="$stamp""
