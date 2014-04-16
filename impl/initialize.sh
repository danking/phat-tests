#!/bin/sh

WORKAREA=$1

[ ! -a "$WORKAREA" ] && mkdir -p $WORKAREA
[ ! -d "$WORKAREA" ] && echo "The workarea, $WORKAREA, is not an extant directory" && exit 1

rm -rf $WORKAREA/stoppednodes
rm -rf $WORKAREA/stoppednodes.bak
rm -rf /tmp/phat-escript.*
rm -rf $WORKAREA/reference-filesystem
rm -rf $WORKAREA/do-log
rm -rf $WORKAREA/command-logs
rm -rf $WORKAREA/pipes*
rm -rf $WORKAREA/logs*
touch $WORKAREA/stoppednodes
touch $WORKAREA/do-log
touch $WORKAREA/command-logs
mkdir $WORKAREA/reference-filesystem
