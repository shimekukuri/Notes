# Zig Reference - Default Comptime

## Abstract
The following contexts are already IMPLICITLY evaluated at
compile time, and adding the 'comptime' keyword would be
superfluous, redundant, and smelly:

   * The container-level scope (outside of any function in a source file)
   * Type declarations of:
       * Variables
       * Functions (types of parameters and return values)
       * Structs
       * Unions
       * Enums
   * The test expressions in inline for and while loops
   * An expression passed to the @cImport() builtin


## Directory

## Useful Links

## Tags
