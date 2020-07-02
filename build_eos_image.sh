#!/bin/bash

set -e

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(dirname "$0")

ROOMSERVICE_BASE_DIR="${SCRIPT_DIR}/roomservices/"

LOG_DIR="$(pwd)/srv/e/logs"
RESULT_DIR="$(pwd)/srv/e/zips"

# Print a usage message.
usage()
{
    cat >&2 <<-EOF

    USAGE : ${SCRIPT_NAME} [-h] -b <branch_name> -d <device_name> [-u <ota_url> ]

    This script makes it easier to build your custom /e/OS image. Note that to make it work you will need the following :

       - Have Docker installed
       - Belong to the Docker group
       - Have at least 100 GB on the file system where you attempt to run your build.
       - Have at least 6 GB of free RAM.

    In case you have a custom roomservice.xml needed for your build please store it under ${ROOMSERVICE_BASE_DIR}/<branch_name>/. 
    Its name must be the device name without any extension, for example j5y17lte for Samsung Galaxy J5 2017. 
    Of course you're strongly encouraged to commit and share your custom roomservice.xml on the repo instead of keeping 
    it deep in a forum. :-)

    This script takes the following parameters into account :

       - -h : print this help message.
       - -b : the /e/OS branch name, for example v0.9-pie or v0.9-oreo
       - -d : the device name as printed by adb shell
       - -u : the OTA URL. This parameter is completely optional.

EOF
}

# Print a log message.
# PARAMS :
# - the message to display.
infoLog()
{
    echo >&2 "$1"
}

# Print a message and exit.
# PARAMS :
# - the error message.
die()
{
    infoLog "$1"
    exit 255
}

# Set up the build environment.
# PARAMS :
# - the branch name
# - the device name
prepareEnvironment()
{
    local branchName="$1"
    local deviceName="$2"

    infoLog "Installing Docker image"
    docker pull "registry.gitlab.e.foundation:5000/e/os/docker-lineage-cicd:community"

    mkdir -p srv/e/{src,zips,logs,ccache,local_manifests}

    local roomServiceFile="${ROOMSERVICE_BASE_DIR}/${branchName}/${deviceName}"
    if [ -f "$roomServiceFile" ]
    then
        infoLog "Using custom RoomService for device ${deviceName}"
        cp "$roomServiceFile" srv/e/local_manifests/roomservice.xml
    else
        infoLog "No custom roomservice.xml file found for branch ${branchName} and device ${deviceName}"
    fi
}

# Build the image by itself.
# PARAMS :
# - the branch name
# - the device name
# - the OTA URL
buildImage()
{
    local branchName="$1"
    local deviceName="$2"
    local otaURL="$3"

    prepareEnvironment "$branchName" "$deviceName"

    local otaParam=""
    if [ -n "$otaURL" ]
    then
        otaParam="-e \"OTA_URL=${otaURL}\""
    fi

    docker run -v "$(pwd)/srv/e/src:/srv/src" \
               -v "$(pwd)/srv/e/zips:/srv/zips" \
               -v "$(pwd)/srv/e/logs:/srv/logs" \
               -v "$(pwd)/srv/e/ccache:/srv/ccache" \
               -v "$(pwd)/srv/e/local_manifests:/srv/local_manifests:delegated" \
               -e "BRANCH_NAME=${1}" \
               -e "DEVICE_LIST=${2}" \
               -e "REPO=https://gitlab.e.foundation/e/os/releases.git" $otaParam \
               "registry.gitlab.e.foundation:5000/e/os/docker-lineage-cicd:community"

   infoLog "Build process complete - check logs under srv/e/logs/${deviceName} to see if it is successful."
   infoLog "If it is successful you should find your image under srv/e/zips/${deviceName}."
}

unset BRANCH_NAME
unset DEVICE_NAME
unset OTA_URL

while getopts "hb:d:u:" opt
do
    case ${opt} in
        h)
            usage
            exit 0
            ;;
        b)
            BRANCH_NAME="$OPTARG"
            ;;
        d)
            DEVICE_NAME="$OPTARG"
            ;;
        u)
            OTA_URL="$OPTARG"
            ;;
        *)
            usage
            die "Unknown parameter !"
    esac
done

if [[ -z "$BRANCH_NAME" ]]
then
    usage
    die "Parameter -b is mandatory !"
fi
if [[ -z "$DEVICE_NAME" ]]
then
    usage
    die "Parameter -d is mandatory !"
fi

buildImage "$BRANCH_NAME" "$DEVICE_NAME" "$OTA_URL"
