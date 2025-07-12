# Nvim How To - Find and Delete

## Abstract
``bash
%s/xyz//g
``
:%s - This part tells Vim to search and replace in the entire buffer.
/xyz - This specifies the search pattern, which is "xyz".
// - This indicates that the replacement should be empty (i.e., delete "xyz").
g - This flag ensures that all occurrences in each line are replaced, not just the first one.


## Directory

## Useful Links

## Tags
[[nvim-how-to]] [[nvim]]
