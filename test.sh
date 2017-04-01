#!/bin/bash

set -e

source ./publish-github-release-assets-helper.sh

#
# TEST RELEASE CREATE
# https://github.com/codeclou/doc/releases/
#

release_id=-1
release_name=1.3
create_github_release_and_get_release_id \
    "codeclou" \
    "doc" \
    $release_name \
    "master" \
    release_id


#
# TEST RELEASE ASSET UPLOAD
# https://github.com/codeclou/doc/releases/
#
upload_asset_to_github_release \
     codeclou \
     doc \
     $release_name \
     $release_id \
     test/ \
     test.json \
     "application/json"

