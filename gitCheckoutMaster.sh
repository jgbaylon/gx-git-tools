#!/bin/bash
BASE_DIR=$1
FILES=$BASE_DIR/*

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    if [ $dir == "kafka-gx-0.8" ]; then
      git checkout gx-0.8
    else
      git checkout master
    fi
    cd $BASE_DIR
  fi
done
