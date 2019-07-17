# publish-github-release-assets-helper

[![](https://codeclou.github.io/publish-github-release-assets-helper/img/github-product-logo-publish-github-release.png)](https://github.com/codeclou/publish-github-release-assets-helper/)

Create [GitHub Release Assets](https://github.com/blog/1547-release-your-software) with ease from your existing bash build script.

&nbsp;

<p align="center"><img src="https://cloud.githubusercontent.com/assets/12599965/24579682/38a5844e-16fa-11e7-8e58-fce0bdd4d6b8.gif" width="80%"></p>



-----

&nbsp;

### Prerequisites

 * `GITHUB_AUTH_TOKEN` environment variable must contain valid [GitHub Personal Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
 * Bash 3 or 4 required
 * `curl` and `jq` required
 * Git Tags should exist before creating a release!
 * Git Tags should be equal to Release-Name!

-----

&nbsp;

### Usage

Use this script inside an existing bash script like so to create a Release `1.3`
and upload `test/test.json` to it.

```bash
#!/bin/bash

set -e

#
# other stuff
#

#
# INSTALL publish-github-release-assets-helper.sh
#
curl -so ./publish-github-release-assets-helper.sh \
"https://raw.githubusercontent.com/codeclou/publish-github-release-assets-helper/\
1.0.0/publish-github-release-assets-helper.sh"
echo "9c02010abdb08080f0dbce4088f9d44abf5de54b9d3\
f11c0caec63d17016d98d9f6b65bb33d64d9d057c37aec6e6\
3d1fac37eedd565ab5dae603b2695276be6d  publish-github-release-assets-helper.sh" \
> ./publish-github-release-assets-helper.sh.sha512sum
sha512sum -c publish-github-release-assets-helper.sh.sha512sum
source ./publish-github-release-assets-helper.sh

#
# PUBLISH RELEASE AND ASSETS
#
release_id=-1
release_name="1.3"
repository_owner="codeclou"
repository_name="doc"
branch_to_create_tag_from="master"   # = target_commitish -> Unused if the Git tag already exists! 
                                     #   https://developer.github.com/v3/repos/releases/#create-a-release

create_github_release_and_get_release_id \
    $repository_owner \
    $repository_name \
    $release_name \
    $branch_to_create_tag_from \
    release_id

upload_asset_to_github_release \
    $repository_owner \
    $repository_name \
    $release_name \
    $release_id \
    test/ \
    test.json \
    "application/json"
```


-----

&nbsp;

### License

[MIT](./LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
