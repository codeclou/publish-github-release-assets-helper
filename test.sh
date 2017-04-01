#!/bin/bash

set -e

source ./publish-github-release-assets-helper.sh


#
# TEST RELEASE UPLOAD:
# https://github.com/codeclou/doc/releases/tag/1.0
#
upload_asset_to_github_release \
         codeclou \
         doc \
         1.0 \
         5945268 \
         test/ \
         test.json \
         "application/json"

# We upload to https://github.com/codeclou/doc/releases
# git tag -a 1.0 -m "rel 1.0"
# git push origin 1.0
