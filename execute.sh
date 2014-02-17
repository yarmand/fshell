#!/bin/bash

HERE=`dirname $0`
. $HERE/lib.sh
debug_var HOSTNAME

. $CONFIG_DIR/execute.config

REMOTE=$1
shift
debug_var REMOTE

BASE_FILE=$DATA_DIR/$REMOTE
debug_var BASE_FILE

init_vars

echo $HOSTNAME >$ID_FILE
encrypt $*

while true ; do
  sleep $SLEEP_DELAY
  if [ -f $LOCK ] ; then
    continue
  fi
  if [ ! -f $OUT ] ; then
    continue
  fi
  cat $OUT
  rm -f $OUT
  exit
done

