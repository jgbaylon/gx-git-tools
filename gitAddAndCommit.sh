#!/bin/bash

MSG=$1

BASE_DIR=~/Artifactory
FILES=$BASE_DIR/*

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then 
    echo "Processing $f file..."
    cd $f

    flagPush='#   (use "git push" to publish your local commits)'
    msgPush=`git status | grep "$flagPush"`
    flagClean='nothing to commit, working directory clean'
    msgClean=`git status | grep "$flagClean"`

    if [[ $flagPush != $msgPush || $flagClean != $msgClean ]]; then
      echo "About to add..."
      git add .
      git commit -m "$MSG"
    fi
    cd $BASE_DIR
  fi
done
