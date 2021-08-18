#!/usr/bin/env bash
#
# This file is part of GEO Knowledge Hub.
# Copyright 2020 GEO Secretariat.
#
# GEO Knowledge Hub is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -eou pipefail

echo "[cli]" > .invenio.private
echo "project_dir = $(pwd)" >> .invenio.private
echo "instance_path = $(pwd)/var/instance" >> .invenio.private
echo "services_setup = True" >> .invenio.private
