#!/usr/bin/env bash
#
# This file is part of GEO Knowledge Hub.
# Copyright 2020 GEO Secretariat.
#
# GEO Knowledge Hub is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -eou pipefail

echo "AfterInstall script started..."

#
# Display the value of some useful variables
#
echo "DATE=$(date)"
echo "USER=$(whoami)"
echo "PWD=$(pwd)"
echo "APPLICATION_NAME=${APPLICATION_NAME}"
echo "DEPLOYMENT_ID=${DEPLOYMENT_ID}"
echo "DEPLOYMENT_GROUP_NAME=${DEPLOYMENT_GROUP_NAME}"
echo "DEPLOYMENT_GROUP_ID=${DEPLOYMENT_GROUP_ID}"
echo "LIFECYCLE_EVENT=${LIFECYCLE_EVENT}"

#
# Check if the GEO Knowledge Hub source code directory was copied
# to the target deploy directory
#
if [ ! -d "${HOME}/geo-knowledge-hub" ]
then
    echo "There is not GEO Knowledge Hub source directory!"
    exit 1
fi

#
# Change the owner and group of the GEO Knowledge Hub source code directory
# and files to the ubuntu user. This script runs under the ubuntu user account.
#
sudo chown -R ubuntu:ubuntu "${HOME}/geo-knowledge-hub"

#
# Change the working directory to the GEO Knowledge Hub source code directory
#
cd "${HOME}/geo-knowledge-hub"

#
# Create a new virtual environment if the script is not running inside one.
#
if [[ ! -v VIRTUAL_ENV ]]
then

    if [ ! -d "$(pwd)/venv" ]
    then
        echo "Creating a new Python 3.7 virtual environment..."

        python3.7 -m venv venv
        source venv/bin/activate
        pip install --upgrade pip
        pip install --upgrade setuptools

        echo "Virtual environment created!"
    else
        echo "Virtual environment folder exists."
        echo "Activating the Python virtual environment...."

        source venv/bin/activate

        echo "Python virtual environment activated!"
    fi
fi

#
# Installing invenio-cli
#
pip install "invenio-cli==0.16.0"

#
# Creating '.invenio.private' file
#
echo "Creating '.invenio.private' file..."

echo "[cli]" > .invenio.private
echo "project_dir = $(pwd)" >> .invenio.private
echo "instance_path = ${VIRTUAL_ENV}/var/instance" >> .invenio.private
echo "services_setup = True" >> .invenio.private

echo "'.invenio.private' file created!"

#
# Adding host IPv4
#
echo "Adding host IPv4 to 'invenio.cfg' file..."

EC2_INSTANCE_IPV4=$(/home/ubuntu/Programs/bin/which-ip.sh)
APP_ALLOWED_HOSTS_ORIGINAL="APP_ALLOWED_HOSTS = \['0\.0\.0\.0', 'localhost', '127\.0\.0\.1'\]"
APP_ALLOWED_HOSTS_NEW="APP_ALLOWED_HOSTS = ['0.0.0.0', 'localhost', '127.0.0.1', '${EC2_INSTANCE_IPV4}']"

sed -i 's/'"${APP_ALLOWED_HOSTS_ORIGINAL}"'/'"${APP_ALLOWED_HOSTS_NEW}"'/g' invenio.cfg

echo "IPv4 added to 'invenio.cfg' file!"

echo "AfterInstall script finished successfully!"
