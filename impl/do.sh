#!/bin/sh

function die() { echo "$@" 1>&2 ; exit 1; }
function echoerr() { echo "$@" 1>&2; }

# arguments

COMMAND=$1
COUNT=$2
N=$3
WORKAREA=$4
SEED=$5
DO_IMPL=$6

[ "$#" -eq 6 ] || die "6 arguments required, $# provided. Valid invocation:

  bash do.sh command_name count N workarea seed do_impl

  - command_name -- the file system command to run
  - count -- the number of times to run, in parallel, the command
  - N -- the number of nodes in the Phat cluster
  - workarea -- a directory in which to place temporary files for testing
  - seed -- the random seed for this file
  - do_impl -- the group-specific implementation of do.sh
"

# functions

function find_live_node() {
    NOT_YET_DEAD_NODE=1
    grep -q "^${NOT_YET_DEAD_NODE}\$" $WORKAREA/stoppednodes
    RESULT=$?
    while [[ $NOT_YET_DEAD_NODE -lt $N && $RESULT -eq 0 ]]
    do
        grep -q "^${NOT_YET_DEAD_NODE}\$" $WORKAREA/stoppednodes
        RESULT=$?
        NOT_YET_DEAD_NODE=`expr $NOT_YET_DEAD_NODE + 1`
    done
    return $NOT_YET_DEAD_NODE
}

# executable portion
if [ -n $SEED ]; then
    RANDOM=$SEED
fi

if [ 0 -ne $? ]; then
    echoerr "Could not create a temporary file, cannot complete"
    exit 1
fi

# begin possible commands

if [ "$COMMAND" = "createfile" ]; then
    find_live_node
    NOT_YET_DEAD_NODE=$?
    for i in `seq 1 $COUNT` # repeat 10
    do
        CONTENTS=${RANDOM}_${RANDOM}
        NAME=file$CONTENTS
        ${DO_IMPL} "createfile" $NOT_YET_DEAD_NODE $NAME $CONTENTS $WORKAREA &
        echo "createfile ${NAME}" >> $WORKAREA/do-log
        echo "${CONTENTS}" > $WORKAREA/reference-filesystem/${NAME}
    done
    sleep 2
fi

