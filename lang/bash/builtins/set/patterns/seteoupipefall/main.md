# Bash Builtins Set Patterns - set -eou pipefail

## Abstract
Known as the strict mode preamble it does the following:

-e (errexit): Causes the script to exit immediately if any command returns a non-zero exit status.

-u (nounset): Treats unset variables as an error and exits immediately, preventing bugs caused by typos in variable
names.

-o pipefail: Ensures that if any command in a pipeline fails (e.g., cmd1 | cmd2), the entire pipeline returns that
non-zero exit code. By default, Bash only reports the exit status of the last command in a pipe.

## Directory

## Useful Links

## Tags
