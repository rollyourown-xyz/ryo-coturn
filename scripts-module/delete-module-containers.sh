#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
  echo "delete-module-containers.sh: Delete the containers of a rollyourown.xyz module"
  echo ""
  echo "Help: delete-module-containerse.sh"
  echo "Usage: ./delete-module-containerse.sh -n hostname"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host from which to back up module container persistent storage"
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
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/../configuration/configuration.yml)"


# Stop module containers
########################

echo ""
echo "Delete "$MODULE_ID" containers on "$hostname""
lxc delete --force "$hostname":coturn

echo "Module container deleted"
echo ""
