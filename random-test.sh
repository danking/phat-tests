#!/bin/bash
# arguments
IMPL=`dirname $0`/impl

F=$1
SEED=$2
RUNS=$3
STUBS=$4
WORKAREA=$5
VERIFYLOG=$6
. $IMPL/setup.sh

[ "$#" -eq 5 -o "$#" -eq 6 ] || die "5 or 6 arguments required, $# provided. Valid invocation:

  bash random-test.sh f random_seed number_of_runs stubs workarea [ verifylog ]

  - f -- the number of failures to resist
  - random_seed -- the random seed
  - number_of_runs -- number of times to throw the dice and run something
  - stubs -- test stub implementation (script or directory)
  - workarea -- a directory in which to place temporary files for testing
  - stop_impl -- the group-specific implementation of stopping a node
"

N=$((F * 2 + 1))

# functions

# timed blocks

function timer_total() {
    # $RANDOM generates numbers in [0, 32767]
    for i in `seq 1 $RUNS`
    do
        R=$RANDOM
        CHILD_SEED=$RANDOM
        if [ $R -le 10000 ];
        then
            bash ${IMPL}/do.sh createfile 5 $N $WORKAREA $CHILD_SEED "$DO_IMPL"
        elif [ $R -le 15000 -a "`wc -l $WORKAREA/stoppednodes | awk {'print $1'}`" -le $F ];
        then
            bash ${IMPL}/stopnode.sh replica $N $WORKAREA $CHILD_SEED "$STOP_IMPL"
        elif [ $R -le 20000 -a -s $WORKAREA/stoppednodes ];
        then
            bash ${IMPL}/revivenode.sh $N $WORKAREA $SEED "$REVIVE_IMPL"
        else
            bash ${IMPL}/do.sh createfile 10 $N $WORKAREA $CHILD_SEED "$DO_IMPL"
        fi
    done
}

# executable portion

RANDOM=$SEED

bash ${IMPL}/initialize.sh $WORKAREA
$STARTNODES_IMPL $N $WORKAREA
time timer_total

sleep 10
echo "Verification..."

if [ -z $VERIFYLOG ]; then
    bash ${IMPL}/verify.sh $N $WORKAREA "$VERIFY_IMPL"
else
    bash ${IMPL}/verify.sh $N $WORKAREA "$VERIFY_IMPL" > $VERIFYLOG
fi
