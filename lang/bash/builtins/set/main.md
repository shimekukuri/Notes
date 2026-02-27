# Bash Builtins - set

## Abstract
-e
Exit immediately if a pipeline (see Pipelines), which may consist of a single simple command (see Simple Commands), a
list (see Lists of Commands), or a compound command (see Compound Commands) returns a non-zero status. The shell does
not exit if the command that fails is part of the command list immediately following a while or until reserved word,
part of the test in an if statement, part of any command executed in a && or || list except the command following the
final && or ||, any command in a pipeline but the last (subject to the state of the pipefail shell option), or if the
command’s return status is being inverted with !. If a compound command other than a subshell returns a non-zero
status because a command failed while -e was being ignored, the shell does not exit. A trap on ERR, if set, is
executed before the shell exits.

This option applies to the shell environment and each subshell environment separately (see Command Execution
Environment), and may cause subshells to exit before executing all the commands in the subshell.

If a compound command or shell function executes in a context where -e is being ignored, none of the commands executed
within the compound command or function body will be affected by the -e setting, even if -e is set and a command
returns a failure status. If a compound command or shell function sets -e while executing in a context where -e is
ignored, that setting will not have any effect until the compound command or the command containing the function call
completes.

## Directory

## Useful Links
[GNU manual - set](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

## Tags
