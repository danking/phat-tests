#!/bin/bash
# timed blocks

# arguments
IMPL=`dirname $0`/impl

F=$1
STUBS=$2
WORKAREA=$3
. $IMPL/setup.sh

[ "$#" -eq 3 ] || die "3 arguments required, $# provided. Valid invocation:

  bash random-test.sh f stubs workarea

  - f -- the number of failures to resist
  - stubs -- test stub implementation (script or directory)
  - workarea -- a directory in which to place temporary files for testing
"

N=$((F * 2 + 1))


# functions

function timer_total() {
    for i in `seq 1 2` # repeat 100
    do
        bash ${IMPL}/stopnode.sh replica $N $WORKAREA $RANDOM "$STOP_IMPL"
        for i in `seq 1 10` # repeat 10
        do
            bash ${IMPL}/do.sh createfile 15 $N $WORKAREA $RANDOM "$DO_IMPL"
        done
        bash ${IMPL}/revivenode.sh $N $WORKAREA $RANDOM "$REVIVE_IMPL"
    done
}

# executable portion

bash ${IMPL}/initialize.sh $WORKAREA
$STARTNODES_IMPL $N $WORKAREA

time timer_total

bash ${IMPL}/verify.sh $N $WORKAREA "$VERIFY_IMPL"
