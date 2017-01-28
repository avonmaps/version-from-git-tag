#!/bin/bash

if [[ -z $(git status -s) ]] ; then
   echo "Source is clean, trying to get release tag when presented"
   RELEASE_VERSION=$(git tag -l --contains HEAD | grep "^v" | sed 's/^v\(.*\)$/\1/')
else
   if [[ -z $(git status -s) ]] ; then
   echo "Source tree is dirty, technical release version will be used"
fi

SNAPSHOT_VERSION=$(git describe --abbrev=0 --tags --match "v[0-9]*" | sed 's/^v\(.*\)$/\1/')-$(date +"%Y%m%d_%H%M%S")-$(echo $WERCKER_GIT_BRANCH |  sed "s/\///")-$WERCKER_GIT_COMMIT-$WERCKER_BUILD_ID
export APP_VERSION=${RELEASE_VERSION:-$SNAPSHOT_VERSION}
echo "=================================================================================================================================="
echo "  VERSION: ${APP_VERSION}  OK"
echo "=================================================================================================================================="
