#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" = false ] ; then
    echo 'Skipped build. This is not a pull request'
    exit 0
fi

if [ -z "$TRAVIS_REPO_SLUG" ]
then
  echo "There is not TRAVIS_REPO_SLUG defined"
  exit 1
fi

if [ -z "$TRAVIS_COMMIT" ]
then
  echo "There is not TRAVIS_COMMIT defined"
  exit 1
fi

if [ -z "$HANDYMAN_API_TOKEN" ] ; then
    echo "There is not HANDYMAN_API_TOKEN defined"
    exit 1
fi

REQUEST="curl -X POST -H \"Content-Type: multipart/form-data\""
FILES=$(find . -type f -name "*.patch")
if [ -z "$FILES" ]
then
    echo "Perfect! There are not patch files"
    exit 0
fi

for FILE in $FILES
do
  REQUEST+=" -F \"data=@$FILE\""
done

REQUEST+=" -H \"Authorization: $HANDYMAN_API_TOKEN\" $APP_HOST/pulls/$TRAVIS_REPO_SLUG/$TRAVIS_PULL_REQUEST/$TRAVIS_COMMIT"
eval $REQUEST