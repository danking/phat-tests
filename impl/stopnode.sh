#!/bin/bash

function echoerr() { echo "$@" 1>&2; }
function die() { echo "$@" 1>&2 ; exit 1; }

# arguments

TYPE=$1
N=$2
WORKAREA=$3
SEED=$4
STOP_IMPL=$5

[ "$#" -eq 5 ] || die "5 arguments required, $# provided. Valid invocation:

  bash stopnode.sh type N workarea seed stop_impl

  - type -- the type of node to revive
  - N -- the number of nodes in the Phat cluster
  - workarea -- a directory in which to place temporary files for testing
  - seed -- the random seed for this file
  - stop_impl -- the group-specific implementation of stopping a node
"


if [ -n $SEED ]; then
    RANDOM=$SEED
fi

# executable portion

if [ "$TYPE" = "primary" ]; then
    echo "Killing primary is unimplemented"
    exit 1;
else
    R=$RANDOM
    i=`expr $R % $N + 1`
    echo "$i" >> $WORKAREA/stoppednodes
    $STOP_IMPL $i
    echo "killed n${i}@localhost"
fi
