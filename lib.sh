# some function for fshell

FSHELL=fshell
DEBUG=false

CONFIG_DIR=~/.$FSHELL
HOSTNAME=`cat $CONFIG_DIR/hostname`
STRING=`cat $CONFIG_DIR/data_dir`
DATA_DIR=`eval echo \$STRING`

function init_vars()
{
  CMD_FILE=$BASE_FILE.cmd
  ID_FILE=$BASE_FILE.id
  OUT=$BASE_FILE.out
  LOCK=$BASE_FILE.lok
  PID_FILE=$BASE_FILE.pid
  debug_var CMD_FILE
  debug_var HOSTNAME
  debug_var CONFIG_DIR
  debug_var DATA_DIR
  debug_var ID_FILE
  debug_var OUT
}

function debug()
{
  if $DEBUG ; then
    echo $*
  fi
}

function debug_var()
{
  name=$1
  value=`eval echo \\$$name`
  debug $name=$value
}

function decrypt()
{
  ID=`cat $ID_FILE`
  openssl rsautl -verify -inkey $CONFIG_DIR/authorized_keys/$ID.pem.pub -pubin -in $CMD_FILE
}

function encrypt()
{
  echo $* | openssl rsautl -sign -inkey $CONFIG_DIR/$HOSTNAME.priv -out $CMD_FILE
}


