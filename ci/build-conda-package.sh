#!/bin/bash

set -e

bucket=$1

if [ "$bucket" == "" ]; then
    echo "usage: build [bucket]"
    exit 2
fi 

bucket="s3://$bucket/linux-64"

pkg="yhat==1.9.0"
pkgname=$(python -c "print '$pkg'.split('==')[0]")
pkgversion=$(python -c "print '$pkg'.split('==')[1]")
echo "building $pkg $pkgname $pkgversion"
set -ex
mkdir /channel
cd /channel
aws s3 sync $bucket/.index.json .
aws s3 sync $bucket/repodata.json .
aws s3 sync $bucket/repodata.json.bz2 .
pip install $pkg
conda package --pkg-name "$pkgname" --pkg-version "$pkgversion"
conda index --no-remove
# aws s3 sync --acl-public . $bucket/
tree .