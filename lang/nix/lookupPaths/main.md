# Nix Lang - Look Up Paths

## Abstract
Lookup path
Syntax

lookup-path = < identifier [ / identifier ]... >

A lookup path is an identifier with an optional path suffix that resolves to a path value if the identifier matches a
search path entry in builtins.nixPath. The algorithm for lookup path resolution is described in the documentation on
builtins.findFile.

Example

<nixpkgs>
/nix/var/nix/profiles/per-user/root/channels/nixpkgs
Example

<nixpkgs/nixos>
/nix/var/nix/profiles/per-user/root/channels/nixpkgs/nixos

## Directory

## Useful Links
[look-up-paths-doc]("https://nix.dev/guides/best-practices.html")

## Tags
