#!/bin/bash

function echoerr() { echo "$@" 1>&2; }
function die() { echo "$@" 1>&2 ; exit 1; }

# arguments

N=$1
WORKAREA=$2
SEED=$3
REVIVE_IMPL=$4

[ "$#" -eq 4 ] || die "4 arguments required, $# provided. Valid invocation:

  bash revivenode.sh N workarea seed revive_impl

  - N -- the number of nodes in the Phat cluster
  - workarea -- a directory in which to place temporary files for testing
  - seed -- the random seed for this file
  - revive_impl -- the group-specific implementation of reviving a node
"

# executable portion
if [ -n $SEED ]; then
    RANDOM=$SEED
fi

read i <$WORKAREA/stoppednodes
# remove the above line from the file
sed -e '1,1d' -i.bak $WORKAREA/stoppednodes

if [ "$i" = "primary" ]; then
    echo "reviving primary is unimplemented"
    exit 1;
else
    $REVIVE_IMPL $i
    echo "revived n${i}@localhost"
fi
