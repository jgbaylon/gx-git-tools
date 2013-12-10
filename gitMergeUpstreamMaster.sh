#!/bin/bash
BASE_DIR=~/Artifactory
FILES=$BASE_DIR/*

echo "===== START GIT FETCH UPSTREAM ====="
./gitFetchUpstream.sh
echo "===== END GIT FETCH UPSTREAM ====="

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    if [ $dir == "kafka-gx-0.8" ]; then
      git merge upstream/gx-0.8
    else
      git merge upstream/master
    fi
    cd $BASE_DIR
  fi
done

echo "===== START GIT PUSH CLEAN ======"
./gitPushClean.sh
echo "===== END GIT PUSH CLEAN ====="

echo "===== START GIT STATUS ====="
./gitStatus.sh
echo "===== END GIT STATUS ====="
