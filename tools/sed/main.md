# Sed

## Abstract
sed (Stream Editor) is a non-interactive command-line tool used to transform and manipulate text line by line. It is commonly used for searching, replacing, inserting, and deleting text within files or from piped input.
DigitalOcean
DigitalOcean

BASIC SYNTAX
sed [options] 'command' file
GeeksforGeeks
GeeksforGeeks

COMMON OPTIONS
-i : Edit files in-place (saves changes directly to the original file).
-n : Suppresses automatic printing of the pattern space (used with 'p' to print specific lines).
-e : Allows execution of multiple editing commands in a single sed call.
-E or -r : Enables extended regular expressions (regex).

CORE COMMANDS AND EXAMPLES
Substitution (s)
The most common use case is replacing text.
Replace first occurrence on each line:
sed 's/old/new/' file.txt
Global replacement (all occurrences on each line):
sed 's/old/new/g' file.txt
Case-insensitive replacement:
sed 's/old/new/gi' file.txt
Replace on a specific line (e.g., line 5):
sed '5s/old/new/' file.txt
Deleting Lines (d)
Delete a specific line (e.g., line 3):
sed '3d' file.txt
Delete a range of lines (e.g., lines 2 to 5):
sed '2,5d' file.txt
Delete from a specific line to the end:
sed '10,d' file.txt [1.2.9, 1.5.2] Delete lines matching a pattern: sed '/pattern/d' file.txt [1.1.9, 1.2.9] Delete all empty lines: sed '/^/d' file.txt
Printing Lines (p)
Requires the -n option to avoid printing every line twice.
Print a specific line:
sed -n '5p' file.txt
Print a range of lines:
sed -n '1,10p' file.txt
Inserting and Appending (i, a)
Insert text before a line (e.g., before line 2):
sed '2i\New line text' file.txt
Append text after a line (e.g., after line 3):
sed '3a\New line text' file.txt
The Grymoire!
The Grymoire!
 +12
HOW SED WORKS INTERNALLY
sed uses two workspaces to handle text:
Pattern Space: A temporary buffer where the current line is held and modified.
Hold Space: A secondary auxiliary buffer used for temporary storage across multiple lines for advanced operations.
Would you like to see examples of advanced regex patterns or how to use multiple sed commands in a single script?

## Directory

## Useful Links

## Tags
