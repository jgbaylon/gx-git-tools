#!/bin/bash
BASE_DIR=~/Projects
FILES=$BASE_DIR/*

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    git branch
    cd $BASE_DIR
  fi
done
