#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
   echo "host-setup.sh: Use ansible to configure a remote host for module deployment"
   echo ""
   echo "Help: host-setup.sh"
   echo "Usage: ./host-setup.sh -n hostname"
   echo "Flags:"
   echo -e "-n hostname \t\t(Mandatory) Name of the host to be configured"
   echo -e "-h \t\t\tPrint this help message"
   echo ""
   exit 1
}

errorMessage()
{
   echo "Invalid option or mandatory input variable is missing"
   echo "Use \"./host-setup.sh -h\" for help"
   exit 1
}

while getopts n:h flag
do
    case "${flag}" in
        n) hostname=${OPTARG};;
        h) helpMessage ;;
        ?) errorMessage ;;
    esac
done

if [ -z "$hostname" ]
then
   errorMessage
fi

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/configuration/configuration.yml)"

# Module-specific host setup for "$MODULE_ID"
if [ -f ""$SCRIPT_DIR"/configuration/"$hostname"_playbooks_executed" ]
then
   echo "Host setup for "$MODULE_ID" module has already been done on "$hostname""
   echo ""
else
   echo "Executing module-specific host setup playbooks for "$MODULE_ID" on "$hostname""
   echo ""
   ansible-playbook -i "$SCRIPT_DIR"/../ryo-host/configuration/inventory_"$hostname" "$SCRIPT_DIR"/host-setup/main.yml --extra-vars "host_id="$hostname""
   touch "$SCRIPT_DIR"/configuration/"$hostname"_playbooks_executed
fi
