#!/bin/bash

set -e

new_version=$1

echo "Upgrading CMB to version: $new_version"


docker tag nginx:latest ressafri/nginx:$new_version

docker push ressafri/nginx:$new_version

tmp_dir=$(mktemp -d)
echo "Using temporary directory: $tmp_dir"

git clone https://github.com/ressafri/test-delete-me.git $tmp_dir

# Update image tag in deployment.yaml
sed -i '' "s|image: nginx:.*|image: nginx:$new_version|g" $tmp_dir/cmb/cmb-webstore/deployment.yaml


cd $tmp_dir/cmb
git add .
git commit -m "Upgrade CMB Webstore to version $new_version"
git push

rm -rf $tmp_dir