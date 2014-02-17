#!/bin/bash

HERE=`dirname $0`
DAEMON=`basename $0`
cd $HERE
HERE=`pwd`
cd -

. $HERE/lib.sh

. $CONFIG_DIR/daemon.config
debug_var SLEEP_DELAY

BASE_FILE=$DATA_DIR/$HOSTNAME
debug_var BASE_FILE

init_vars

function kill_previous()
{
  kill -9 `cat $PID_FILE`
}

function cleanup()
{
  rm -f $LOCK
  rm -f $PID_FILE
  rm -f $CMD_FILE
  rm -f $ID_FILE
}

cleanup
RESTARTER=3600

while true ; do
  printf "$RESTARTER     \r"
  RESTARTER=`expr $RESTARTER - 1`

  if [ $RESTARTER -lt 0 ] ; then
    debug "restarting daemon $HERE/$DAEMON"
    exec $HERE/$DAEMON
  fi

  sleep $SLEEP_DELAY
  if [ ! -f $CMD_FILE ] ; then continue ; fi

  if [ -f $LOCK ] ; then
    cmd_date=`stat -f '%a' $CMD_FILE`
    lock_date=`stat -f '%a' $LOCK`
    if [ $cmd_date -gt $lock_date ] ; then
      kill_previous
      cleanup
    else
      continue
    fi
  fi

  CMD=`decrypt`

  touch $LOCK
  $SHELL 2>&1 > $OUT << EOCMD
echo \$\$ >$PID_FILE
$CMD
EOCMD
cleanup
debug `cat $OUT`
done

