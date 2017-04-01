# publish-github-release-assets-helper

Create [GitHub Release Assets](https://github.com/blog/1547-release-your-software) with ease from your existing bash build script.


-----

&nbsp;

### Usage

Use this script inside an existing bash script like so to create a Release `1.3`
and upload `test/test.json` to it.

Note:
 * `GITHUB_AUTH_TOKEN` environment variable must contain valid [GitHub Personal Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)

```bash
#!/bin/bash

set -e

#
# other stuff
#

source ./publish-github-release-assets-helper.sh

release_id=-1
release_name="1.3"
repository_owner="codeclou"
repository_name="doc"
branch_to_create_tag_from="master"

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
