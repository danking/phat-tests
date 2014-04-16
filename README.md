# Running the Test Scripts
## test1.sh
We run test1.sh with this invocation

    bash phat-tests/test1.sh 11 phat-tests/impl workspace

The first argument, `11`, is f.

The second argument, `tests/impl`, must be the path, relative the current
working directory, to the `impl` directory containing helper scripts for the
test framework. NB: This is not the directory containing group-specific
scripts. NB2: Don't include the trailing slash.

The third argument, `workspace`, is a directory to store temporary files in. It
will be created if it doesn't exist.

## random-test.sh
Here's the help doc:

    bash random-test.sh f random_seed number_of_runs impl_directory workarea [ verifylog ]

      - f -- the number of failures to resist
      - random_seed -- the random seed
      - number_of_runs -- number of times to throw the dice and run something
      - impl_directory -- a path, relative to CWD, to the impl directory, don't include a trailing slash
      - workarea -- a directory in which to place temporary files for testing
      - stop_impl -- the group-specific implementation of stopping a node

The ERIC group can run `random-test.sh` like this:

    bash phat-tests/random-test.sh 10 1 10 phat-tests/impl workspace

# Modifying The Scripts For Your Group

In both `random-test.sh` and `test1.sh` you can see a block of variables with
names ending in `_IMPL`. These are the variables you should set appropriately
for your group. They must be "executable" in a bash sense. The arguments to
these commands are as follows:

  - `DO_IMPL command living_server_number filename file_contents workarea`

  Currently, the only command is `createfile`. You may create temporary files in
  the workarea, but please use randomized names to avoid clashing with some
  bookkeeping files the scripts maintain.

  - `STOP_IMPL node_number_to_kill`

  - `REVIVE_IMPL node_number_to_revive`

  - `STARTNODES_IMPL number_of_nodes`

  - `VERIFY_IMPL living_server_number filename file_contents`

  This should return a non-zero exit status if there doesn't exist a file named
  `filename` with the contents `file_contents`.
