if [ -d "$STUBS" -a -f "$STUBS/do.sh" ]; then
    DO_IMPL="bash $STUBS/do.sh"
    STOP_IMPL="bash $STUBS/stop.sh"
    REVIVE_IMPL="bash $STUBS/revive.sh"
    STARTNODES_IMPL="bash $STUBS/start.sh"
    VERIFY_IMPL="bash $STUBS/verify.sh"
elif [ -f "$STUBS" -a -x "$STUBS" ]; then
    DO_IMPL="$STUBS do"
    STOP_IMPL="$STUBS stop"
    REVIVE_IMPL="$STUBS revive"
    STARTNODES_IMPL="$STUBS start"
    VERIFY_IMPL="$STUBS verify"
elif [ -f "$STUBS" ] && grep DO_IMPL $STUBS >/dev/null 2>&1; then
    . $STUBS
else
    echo "Bad STUBS setting" 1>&2
    exit 1
fi

