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
# Load GEO Knowledge Hub demo data
#
echo "Loading GEO Knowledge Hub demo data..."

declare -a demo_data_folders=("sen2-agri-V2")

GKH_DEMO_DATA="/home/gribeiro/Devel/github/gqueiroz/demo-knowledge-packages"

#echo ${GKH_DEMO_DATA}

for data_dir in "${demo_data_folders[@]}"
do
    folder_path="${GKH_DEMO_DATA}/${data_dir}"
    #echo ${folder_path}

    for f in ${folder_path}/*.json
    do
        if [ ! -f "${f}" ]
        then
            echo "No file exists in directory '${folder_path}'!"
            break
        fi

        PID=$(curl -k \
                   --silent \
                   -XPOST \
                   -H "Content-Type: application/json" \
                   https://127.0.0.1:5000/api/rdm-records \
                   -d "@${f}" | jq -C -r ".pid")

        echo "${f}: loaded!"

        curl -k --silent -X POST https://127.0.0.1:5000/api/rdm-records/${PID}/draft/actions/publish > /dev/null 2>&1

        echo "${f}: published!"

    done

done

echo "GEO Knowledge Hub demo data loaded!"
