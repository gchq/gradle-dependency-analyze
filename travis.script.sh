#!/bin/bash

#exit script on any error
set -e

RELEASE_VERSION_REGEX='^v[0-9]+\.[0-9]+\.[0-9].*$'

#Shell Colour constants for use in 'echo -e'
#e.g.  echo -e "My message ${GREEN}with just this text in green${NC}"
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Colour 

#establish what version we are building
if [ -n "$TRAVIS_TAG" ]; then
    #Tagged commit so use that as our version, e.g. v6.0.0
    VERSION="${TRAVIS_TAG}"
else
    #No tag so use the branch name as the version, e.g. dev
    VERSION="${TRAVIS_BRANCH}"
fi

#Dump all the travis env vars to the console for debugging
echo -e "TRAVIS_BUILD_NUMBER: [${GREEN}${TRAVIS_BUILD_NUMBER}${NC}]"
echo -e "TRAVIS_COMMIT:       [${GREEN}${TRAVIS_COMMIT}${NC}]"
echo -e "TRAVIS_BRANCH:       [${GREEN}${TRAVIS_BRANCH}${NC}]"
echo -e "TRAVIS_TAG:          [${GREEN}${TRAVIS_TAG}${NC}]"
echo -e "TRAVIS_PULL_REQUEST: [${GREEN}${TRAVIS_PULL_REQUEST}${NC}]"
echo -e "TRAVIS_EVENT_TYPE:   [${GREEN}${TRAVIS_EVENT_TYPE}${NC}]"
echo -e "VERSION:             [${GREEN}${VERSION}${NC}]"

#Normal commit/PR/tag build
extraBuildArgs=""

if [ -n "$TRAVIS_TAG" ]; then

    if [[ "$TRAVIS_TAG" =~ ${RELEASE_VERSION_REGEX} ]]; then
        echo "This is a release version so add gradle arg for publishing libs to Bintray"
        extraBuildArgs="bintrayUpload"
    fi
fi

echo -e "extraBuildArgs:      [${GREEN}${extraBuildArgs}${NC}]"

./gradlew -Pversion=$TRAVIS_TAG clean build ${extraBuildArgs}

exit 0
