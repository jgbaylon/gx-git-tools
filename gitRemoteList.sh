#!/bin/bash
BASE_DIR=~/Artifactory
FILES=$BASE_DIR/*

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    git remote -v
    cd $BASE_DIR
  fi
done
