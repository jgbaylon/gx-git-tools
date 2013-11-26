#!/bin/bash
BASE_DIR=$1
FILES=$BASE_DIR/*

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    git merge upstream/master
    cd $BASE_DIR
  fi
done
