#!/bin/bash

rm repo/samuel_repo*

echo "repo-add"
repo-add -n -R repo/samuel_repo.db.tar.gz repo/*.pkg.tar.zst

echo "####################################"
echo "Repo Updated!!"
echo "####################################"