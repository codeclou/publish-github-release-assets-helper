#!/bin/bash

####################################################################################
# MIT License
# Copyright (c) 2017 Bernhard Grünewaldt
# See https://github.com/codeclou/publish-github-release-assets-helper/blob/master/LICENSE
####################################################################################

set -e

####################################################################################
#
# COLORS
#
####################################################################################

export CLICOLOR=1
C_RED='\x1B[31m'
C_CYN='\x1B[96m'
C_GRN='\x1B[32m'
C_MGN='\x1B[35m'
C_RST='\x1B[39m'

####################################################################################
#
# FUNCTIONS
#
####################################################################################

# USAGE:
#  upload_asset_to_github_release \
#        {owner} \
#        {repo} \
#        {release_name} \
#        {release_id} \
#        {filepath} \
#        {filename} \
#        {mime_type}
#
# -------
# Example:
#  upload_asset_to_github_release \
#         codeclou \
#         foo \
#         1.0 \
#         123 \
#         build-results/ \
#         swagger.json \
#         "application/json"
#
function upload_asset_to_github_release {
    local owner=$1
    local repo=$2
    local release_name=$3
    local release_id=$4
    local filepath=$5
    local filename=$6
    local mime_type=$7

    #
    # LIST ASSETS
    #
    local assets=$(curl -s \
        --fail \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: token ${GITHUB_AUTH_TOKEN}" \
        "https://api.github.com/repos/${owner}/${repo}/releases/${release_id}/assets" \
        | jq ".")

    #
    # CHECK IF ASSET EXISTS
    #
    local asset_id=$(echo $assets | jq -r ".[] | select(.name == \"$filename\") | .id")

    #
    # DELETE ASSET IF EXISTS
    #
    if [ "$asset_id" != "" ]
    then
        local delete_existing_asset_response=$(curl \
             -s -o /dev/null \
             -w "%{http_code}" \
             -H "Content-Type: ${mime_type}" \
             -H "Authorization: token ${GITHUB_AUTH_TOKEN}" \
             -X DELETE \
             "https://api.github.com/repos/${owner}/${repo}/releases/assets/${asset_id}")
        if [[ "$delete_existing_asset_response" != "204" ]]
        then
            echo -e $C_CYN">> publish asset ........:${C_RST}${C_RED} DELETING EXISTING${C_RST} ${filename} of release ${release_name} failed with http ${delete_existing_asset_response}"
            exit 1
        else
            echo -e $C_CYN">> publish asset ........:${C_RST}${C_GRN} DELETING EXISTING${C_RST} ${filename} of release ${release_name} succeeded with http ${delete_existing_asset_response}"
        fi
    fi

    #
    # UPLOAD ASSET
    #
    local upload_response_status=$(curl \
         -s -o /dev/null \
         -w "%{http_code}" \
         -H "Content-Type: ${mime_type}" \
         -H "Authorization: token ${GITHUB_AUTH_TOKEN}" \
         -X POST \
         --data-binary "@${filepath}${filename}" \
         "https://uploads.github.com/repos/${owner}/${repo}/releases/${release_id}/assets?name=${filename}")
    if [[ "$upload_response_status" != "201" ]]
    then
        echo -e $C_CYN">> publish asset ........:${C_RST}${C_RED} UPLOADING        ${C_RST} ${filename} of release ${release_name} failed with http ${upload_response_status}"
        exit 1
    else
        echo -e $C_CYN">> publish asset ........:${C_RST}${C_GRN} UPLOADING        ${C_RST} ${filename} of release ${release_name} succeeded with http ${upload_response_status}"
    fi

    return 0
}

function create_github_release_and_get_release_id {

    local release_id=$(curl -i \
        --fail \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: token ${GITHUB_AUTH_TOKEN}" \
        https://api.github.com/repos/codeclou-int/customfield-editor-plugin/releases/tags/$GIT_BRANCH_SHORT \
        | jq "{.id}")

    if (( release_id > 0 ))
    then
      echo "release does exist"
    else
        echo "creating release"
    fi
}



