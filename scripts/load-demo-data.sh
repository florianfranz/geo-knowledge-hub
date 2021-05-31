#!/usr/bin/env bash
#
# This file is part of GEO Knowledge Hub.
# Copyright 2020 GEO Secretariat.
#
# GEO Knowledge Hub is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -eou pipefail

#
# Check if containers are running
#
echo "Checking if GEO Knowledge Hub docker containers are all up..."

#GKH_PROJECT_SHORT_NAME=$(awk -F "=" '/project_shortname/ {print $2}' .invenio | tr -d ' ')

#echo "GEO Knowledge Hub project_shortname is: '${GKH_PROJECT_SHORT_NAME}'"

#docker-compose --file docker-compose.full.yml up --build --detach

#sleep 30

echo "GEO Knowledge Hub containers checked!"

#
# Create user and generate access token
#
echo "Creating user to ingest demo data..."

#docker exec -it \
#            geo-knowledge-hub_web-api_1 \
#            invenio users create ${GEO_KNOWLEDGE_HUB_USER_NAME} \
#            --password=${GEO_KNOWLEDGE_HUB_USER_PASSWORD} \
#            --active

#docker exec -it \
#            geo-knowledge-hub_web-api_1 \
#            invenio roles add ${GEO_KNOWLEDGE_HUB_USER_NAME} admin

#GKH_TOKEN=$(docker exec -it \
#                        geo-knowledge-hub_web-api_1 \
#                        invenio tokens create --name gkhub-ingest --user ${GEO_KNOWLEDGE_HUB_USER_NAME} | tr -d '\n' |  tr -d '\r' | tr -d ' ')

echo "User, role and token created!"

#
# Locate instanse IP
#
EC2_INSTANCE_IPV4=$(/home/ubuntu/Programs/bin/which-ip.sh)

#
# Load GEO Knowledge Hub demo data
#
echo "Loading GEO Knowledge Hub demo data..."

declare -a demo_data_folders=("bdc")

GKH_DEMO_DATA=$(/home/ubuntu/Programs/bin/where-is-demo-data.sh)

for data_dir in "${demo_data_folders[@]}"
do
    folder_path="${GKH_DEMO_DATA}/${data_dir}"

#    gkh-package-loader load --verbose \
#                            --url https://${EC2_INSTANCE_IPV4}/api \
#                            --access-token "${GKH_TOKEN}" \
#                            --knowledge-package "${folder_path}/knowledge-package.json" \
#                            --resources-dir "${folder_path}"

done

echo "GEO Knowledge Hub demo data loaded!"
