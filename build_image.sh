#!/bin/bash

set -e

mkdir -p srv/e/{src,zips,logs,ccache,local_manifests}

docker pull "registry.gitlab.e.foundation:5000/e/os/docker-lineage-cicd:community"

docker run -v "$(pwd)/srv/e/src:/srv/src" -v "$(pwd)/srv/e/zips:/srv/zips" -v "$(pwd)/srv/e/logs:/srv/logs" -v "$(pwd)/srv/e/ccache:/srv/ccache" -e "BRANCH_NAME=${1}" -e "DEVICE_LIST=${2}" -e "REPO=https://gitlab.e.foundation/e/os/releases.git" "registry.gitlab.e.foundation:5000/e/os/docker-lineage-cicd:community"
