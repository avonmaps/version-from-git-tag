#!/bin/bash

if [[ -z $(git status -s) ]] ; then
   echo "Source is clean, trying to get release tag when presented"
   export GIT_DIRTY="false"
else
   echo "Source tree is dirty, technical release version will be used"
   export GIT_DIRTY="true"
fi

RELEASE_VERSION=$(git tag -l --contains HEAD | grep "^v" | sed 's/^v\(.*\)$/\1/')
BASE_VERSION=$(git describe --abbrev=0 --tags --match "v[0-9]*" | sed 's/^v\(.*\)$/\1/')
echo "Base version from git: $BASE_VERSION"
BASE_VERSION=${BASE_VERSION:-"0.0.1"}

if [[ -z $RELEASE_VERSION ]] ; then
   echo "Git commit doesn't tagged with v tag, snapshot version will be used from $BASE_VERSION"
   export MAKE_RELEASE="false"
else
   echo "Git commit tagged with v tag, release version will be used: $RELEASE_VERSION"
   export MAKE_RELEASE="true"
fi

SNAPSHOT_VERSION=$BASE_VERSION-$(date +"%Y%m%d_%H%M%S")-$(echo $WERCKER_GIT_BRANCH |  sed "s/\///")-$WERCKER_GIT_COMMIT-$WERCKER_BUILD_ID
echo "Snapshot version: $SNAPSHOT_VERSION"

export APP_VERSION=${RELEASE_VERSION:-$SNAPSHOT_VERSION}
echo "=================================================================================================================================="
echo "  VERSION: ${APP_VERSION}  OK"
echo "=================================================================================================================================="
