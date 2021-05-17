#!/usr/bin/env bash
#
# This file is part of GEO Knowledge Hub.
# Copyright 2020 GEO Secretariat.
#
# GEO Knowledge Hub is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -eou pipefail

echo "ApplicationStart script started..."

#
# Check if there is a GEO Knowledge Hub source directory
#
if [ ! -d "${HOME}/geo-knowledge-hub" ]
then
    echo "There is not GEO Knowledge Hub source directory!"

    exit 1
fi

cd "${HOME}/geo-knowledge-hub"

#
# Activate the virtual environment if needed.
#
if [[ ! -v VIRTUAL_ENV ]]
then
    source venv/bin/activate

    echo "Virtual environment activated!"
fi

invenio-cli containers build

invenio-cli containers setup --no-demo-data

invenio-cli containers start

#
# Load GEO Knowledge Hub demo data
#
./scripts/load-demo-data.sh


echo "ApplicationStart script finished successfully!"
