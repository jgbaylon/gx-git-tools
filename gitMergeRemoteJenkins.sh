#!/bin/bash
BASE_DIR=~/Projects
GX_FILES=$BASE_DIR/gx-*
NEW_GX_FILES=$BASE_DIR/new-gx-*
LWES_FILES=$BASE_DIR/lwes-*
KAFKA_FILES=$BASE_DIR/kafka-*

echo "===== START GIT CHECKOUT JENKINS ====="
./gitCheckoutJenkins.sh
echo "===== END GIT CHECKOUT JENKINS ====="

cd $BASE_DIR

for f in $GX_FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    if [ $dir == "kafka-trunk" ]; then
      git pull git@github.com:jgbaylon/kafka.git trunk
    else
      git pull git@github.com:jgbaylon/$dir.git
    fi
    cd $BASE_DIR
  fi
done

for f in $LWES_FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    git pull git@github.com:jgbaylon/$dir.git
    cd $BASE_DIR
  fi
done

for f in $KAFKA_FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    if [ $dir == "kafka-trunk" ]; then
      git pull git@github.com:jgbaylon/kafka.git trunk
    fi
    cd $BASE_DIR
  fi
done

for f in $NEW_GX_FILES
do
  if [ -d $f ]; then
    echo "Processing $f file..."
    cd $f
    dir=`echo $f | rev | cut -d\/ -f1 | rev`
    dir=`echo $dir | cut -d- -f2-`
    git pull git@bitbucket.org:jgbaylon/$dir.git
    cd $BASE_DIR
  fi
done

echo "===== START GIT PUSH CLEAN ====="
./gitPushClean.sh
echo "===== END GIT PUSH CLEAN ====="

echo "===== START GIT STATUS ====="
./gitStatus.sh
echo "===== END GIT STATUS ====="
