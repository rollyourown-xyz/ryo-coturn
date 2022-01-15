#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
   echo "deploy-module.sh: Use terraform to deploy module"
   echo ""
   echo "Help: deploy-module.sh"
   echo "Usage: ./deploy-module.sh -n hostname -v version"
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
   echo "Use \"./deploy-module.sh -h\" for help"
   exit 1
}

while getopts n:v:h flag
do
    case "${flag}" in
        n) hostname=${OPTARG};;
        v) version=${OPTARG};;
        h) helpMessage ;;
        ?) errorMessage ;;
    esac
done

if [ -z "$hostname" ] || [ -z "$version" ]
then
   errorMessage
fi

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/../configuration/configuration.yml)"

echo "Deploying components for "$MODULE_ID" module on "$hostname""
echo ""

# Set up / switch to module workspace for host
if [ -f ""$SCRIPT_DIR"/../configuration/"$hostname"_workspace_created" ]
then
   echo "Workspace for host "$hostname" already created, switching to workspace"
   echo ""
   echo "Executing command terraform -chdir="$SCRIPT_DIR"/../module-deployment workspace select $hostname"
   echo ""
   terraform -chdir="$SCRIPT_DIR"/../module-deployment workspace select $hostname
   echo ""
else
   echo "Creating workpsace for host "$hostname" and switching to it"
   echo ""
   echo "Executing command: terraform -chdir="$SCRIPT_DIR"/../module-deployment workspace new $hostname"
   echo ""
   terraform -chdir="$SCRIPT_DIR"/../module-deployment workspace new $hostname
   echo ""
   touch "$SCRIPT_DIR"/../configuration/"$hostname"_workspace_created
fi

echo "Executing command: terraform -chdir="$SCRIPT_DIR"/../module-deployment init"
echo ""
terraform -chdir="$SCRIPT_DIR"/../module-deployment init
echo ""
echo "Executing command: terraform -chdir="$SCRIPT_DIR"/../module-deployment apply -input=false -auto-approve -var \"host_id=$hostname\" -var \"image_version=$version\""
echo ""
terraform -chdir="$SCRIPT_DIR"/../module-deployment apply -input=false -auto-approve -var "host_id=$hostname" -var "image_version=$version"
echo ""
echo "Completed"


# Update ryo-host deployed-modules array for "$hostname"

# Get Module ID from configuration file
MODULE_ID="$(yq eval '.module_id' "$SCRIPT_DIR"/../configuration/configuration.yml)"

# Check existence of deployed-modules file and create it not existing
if [ ! -f "$SCRIPT_DIR"/../../ryo-host/backup-restore/deployed-modules_"$hostname".yml ]
then
  cp "$SCRIPT_DIR"/../../ryo-host/backup-restore/deployed-modules_TEMPLATE.yml "$SCRIPT_DIR"/../../ryo-host/backup-restore/deployed-modules_"$hostname".yml
fi

# Add module to deployed-modules array for "$hostname"
if [ ! yq eval '. |= any_c(. == "$MODULE_ID")' "$SCRIPT_DIR"/../../ryo-host/backup-restore/deployed-modules_"$hostname".yml ]
  yq eval -i '. += "$MODULE_ID"' "$SCRIPT_DIR"/../../ryo-host/backup-restore/deployed-modules_"$hostname".yml
fi

# Delete the null entry if it exists:
yq eval -i 'del(.[] | select(. == null))' "$SCRIPT_DIR"/../../ryo-host/backup-restore/deployed-modules_"$hostname".yml
