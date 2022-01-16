#!/bin/bash

# deploy.sh
# This script deploys a module 


# Help and error messages
#########################

helpMessage()
{
  echo "deploy.sh: Deploy a rollyourown.xyz module"
  echo "Usage: ./deploy.sh -n hostname -v version"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host on which to deploy the module"
  echo -e "-v version \t\t(Mandatory) Version stamp for images to deploy, e.g. 20210101-1"
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
echo "rollyourown.xyz deployment script for "$MODULE_ID""


# Deploy Module
################

# Run host setup playbooks for module
echo ""
echo "Running module-specific host setup for "$MODULE_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-module/host-setup.sh -n "$hostname"

# Run packer image build for module
echo ""
echo "Running build-images script for "$MODULE_ID" module on "$hostname" with version "$version""
/bin/bash "$SCRIPT_DIR"/scripts-module/build-images.sh -n "$hostname" -v "$version"

# Deploy module
echo ""
echo "Deploying image(s) "$MODULE_ID" module on "$hostname" using images with version "$version""
/bin/bash "$SCRIPT_DIR"/scripts-module/deploy-module.sh -n "$hostname" -v "$version"
