# Running the Test Scripts
## test1.sh
We run test1.sh with this invocation

    bash phat-tests/test1.sh 11 STUBS workspace

The first argument, `11`, is f.

The second argument, `STUBS`, is either a directory name or an executable
script. If a directory, it should contain scripts named `STUBS/do.sh`,
`STUBS/startnodes.sh`, and so forth. If a script, it will be executed
like `STUBS do ...`, `STUBS startnodes ...`, and so forth.

The third argument, `workspace`, is a directory to store temporary files in. It
will be created if it doesn't exist.

## random-test.sh
Here's the help doc:

    bash random-test.sh f random_seed number_of_runs stubs workarea [ verifylog ]

      - f -- the number of failures to resist
      - random_seed -- the random seed
      - number_of_runs -- number of times to throw the dice and run something
      - stubs -- test stub implementation (script or directory)
      - workarea -- a directory in which to place temporary files for testing
      - stop_impl -- the group-specific implementation of stopping a node

The ERIC group can run `random-test.sh` like this:

    bash phat-tests/random-test.sh 10 1 10 ERICSTUBS workspace

# Modifying The Scripts For Your Group

The stub subcommands are as follows. Your stub script should
understand the subcommands, or your stub directory should contain
scripts named `STUBDIR/subcommand.sh` for each subcommand.

  - `do instruction living_server_number filename file_contents workarea`

  Currently, the only instruction is `createfile`. You may create
  temporary files in the workarea, but please use randomized names to
  avoid clashing with some bookkeeping files the scripts maintain.

  - `stop node_number_to_kill`

  - `revive node_number_to_revive`

  - `start number_of_nodes`

  - `verify living_server_number filename file_contents`

  This should return a non-zero exit status if there doesn't exist a file named
  `filename` with the contents `file_contents`.
