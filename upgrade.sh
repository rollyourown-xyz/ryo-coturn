#!/bin/bash

# upgrade.sh
# This script upgrades a module 


# Help and error messages
#########################

helpMessage()
{
  echo "upgrade.sh: Upgrade a rollyourown.xyz module"
  echo "Usage: ./upgrade.sh -n hostname -v version"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host on which to upgrade the project"
  echo -e "-v version \t\t(Mandatory) Version stamp for images to upgrade, e.g. 20210101-1"
  echo -e "-h \t\t\tPrint this help message"
  echo ""
  exit 1
}

errorMessage()
{
  echo "Invalid option or input variables are missing"
  echo "Use \"./deploy.sh -h\" for help"
  exit 1
}


# Command-line input handling
#############################

while getopts n:v:h flag
do
  case "${flag}" in
    n) hostname=${OPTARG};;
    v) version=${OPTARG};;
    h) helpMessage ;;
    ?) errorMessage ;;
  esac
done

if [ -z "$hostname" ] || [ -z "$version" ]; then
  errorMessage
fi


# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/configuration/configuration.yml)"


# Info
echo "rollyourown.xyz upgrade script for "$MODULE_ID""


# Update module repository
##########################

echo "Refreshing module repository with git pull to get the current version"
cd "$SCRIPT_DIR" && git pull


# Upgrade module components
############################

# Build new module images
echo ""
echo "Building new image(s) for "$MODULE_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-module/build-images.sh -n "$hostname" -v "$version"

# Deploy module containers
echo ""
echo "Deploying new image(s) for "$MODULE_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-module/deploy-module.sh -n "$hostname" -v "$version"
