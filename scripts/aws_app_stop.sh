#!/usr/bin/env bash
#
# This file is part of GEO Knowledge Hub.
# Copyright 2020-2021 GEO Secretariat.
#
# GEO Knowledge Hub is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -eou pipefail

echo "ApplicationStop script started..."

#
# Check if there is a previous GEO Knowledge Hub source directory
#
if [ ! -d "${HOME}/geo-knowledge-hub" ]
then
    echo "There is not a previous version to stop."

    exit 0
fi

#
# If there is a previous source code folder,
# stop all running containers
#
cd "${HOME}/geo-knowledge-hub"

#
# Activate the virtual environment if needed.
#
if [[ ! -v VIRTUAL_ENV ]]
then
    source venv/bin/activate

    echo "Virtual environment activated!"
fi

invenio-cli containers destroy

cd "${HOME}"

#rm -rf /home/ubuntu/geo-knowledge-hub

echo "ApplicationStop script finished successfully!"
