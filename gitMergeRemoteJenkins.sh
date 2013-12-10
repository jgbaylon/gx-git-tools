#!/bin/bash
BASE_DIR=~/Projects
FILES=$BASE_DIR/*

echo "===== START GIT CHECKOUT JENKINS ====="
./gitCheckoutJenkins.sh
echo "===== END GIT CHECKOUT JENKINS ====="

cd $BASE_DIR

for f in $FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    if [ $dir == "kafka-gx-0.8" ]; then
      git pull git@github.com:jgbaylon/kafka.git gx-0.8
    else
      git pull git@github.com:jgbaylon/$dir.git
    fi
    cd $BASE_DIR
  fi
done

echo "===== START GIT PUSH CLEAN ====="
./gitPushClean.sh
echo "===== END GIT PUSH CLEAN ====="

echo "===== START GIT STATUS ====="
./gitStatus.sh
echo "===== END GIT STATUS ====="
