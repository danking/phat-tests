#!/bin/bash
# timed blocks

# arguments

F=$1
IMPL=$2
WORKAREA=$3

[ "$#" -eq 3 ] || die "3 arguments required, $# provided. Valid invocation:

  bash random-test.sh f impl_directory workarea

  - f -- the number of failures to resist
  - impl_directory -- a path, relative to CWD, to the impl directory, don't include a trailing slash
  - workarea -- a directory in which to place temporary files for testing
"

N=$((F * 2 + 1))

ERIC=/Users/danking/projects/erlang-phat/tests/eric

DO_IMPL="bash ${ERIC}/do.sh"
STOP_IMPL="bash ${ERIC}/stopnode.sh"
REVIVE_IMPL="bash ${ERIC}/revivenode.sh"
STARTNODES_IMPL="bash ${ERIC}/startnodes.sh"
VERIFY_IMPL="bash ${ERIC}/verify.sh"

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
