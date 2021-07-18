#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
   echo "build-images.sh: Use packer to build images for deployment"
   echo ""
   echo "Help: build-images.sh"
   echo "Usage: ./build-images.sh -n hostname -v version"
   echo "Flags:"
   echo -e "-n hostname \t\t(Mandatory) Name of the host for which to build images"
   echo -e "-v version \t\t(Mandatory) Version stamp to apply to images, e.g. 20210101-1"
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

# Default webhook and consul-template versions

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


echo "Building images for ryo-coturn module on "$hostname""
echo ""
echo "Building Coturn image"
echo ""
echo "Executing command: packer build -var \"host_id="$hostname"\" -var \"version="$version"\" "$SCRIPT_DIR"/image-build/coturn.pkr.hcl"
echo ""
packer build -var "host_id="$hostname"" -var "version="$version"" "$SCRIPT_DIR"/image-build/coturn.pkr.hcl
echo ""
