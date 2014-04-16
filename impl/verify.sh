#!/bin/bash

die() { echo "$@" 1>&2 ; exit 1; }
echoerr() { echo "$@" 1>&2; }

# arguments

N=$1
WORKAREA=$2
VERIFY_IMPL=$3

[ "$#" -eq 3 ] || die "3 arguments required, $# provided. Valid invocation:

  bash verify.sh N workarea verify_impl

  - N -- the number of nodes in the Phat cluster
  - workarea -- a directory in which to place temporary files for testing
  - verify_impl -- a group-specific implementation of file verification
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

FAILURES=0

while read line
do
    echo "verifying $line"
    if [[ "$line" =~ createfile\ (.*) ]]; then
        CONTENTS=$(cat $WORKAREA/reference-filesystem/${BASH_REMATCH[1]})
        VR_FILE=file${CONTENTS}
        find_live_node
        NOT_YET_DEAD_NODE=$?

        $VERIFY_IMPL $NOT_YET_DEAD_NODE $VR_FILE $CONTENTS

        if [ $? -ne 0 ]
        then
            FAILURES=`expr $FAILURES + 1`
        fi
    fi
done < $WORKAREA/do-log

echo "Verification found $FAILURES failures"
exit $FAILURES
