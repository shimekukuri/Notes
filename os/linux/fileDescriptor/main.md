# Linux - File Descriptor

## Abstract

A file descriptor is a non negative integer that uniquely identifies an open I/O resource within a process

The I/O resource could be:
    - A regular filesystem file
    - A directory
    - A pipe or FIFO
    - A socket (network or UNIX-domain)
    - A device (e.g. /dev/sda, terminals)
Even some pseudo-files (e.g. files in /proc)

The file descriptor is a kind of “handle” or “reference” that the kernel gives you so that you can perform operations
(read, write, close, etc.) on that resource via system calls. 

Negative values (typically -1) are used to signal errors (e.g. if opening a file fails) — you don’t get a valid file descriptor.

How It Works Internally
Here’s a simplified model of the underlying data structures and flow:
Per-process FD table
Each process has a table (array or list) of file descriptors. Each FD in that table points to an entry in the kernel’s
file table. 

System-wide file table / open file descriptions
The kernel maintains a table of “open file descriptions” (or file table entries). These entries keep state common to
all file descriptors that refer to the same underlying resource, such as:
Current file offset (for read/write)
Access mode and flags (read, write, append, etc.)
A reference to the “inode” (for regular files) or other underlying resource
Reference count (how many FDs or processes point to it)
Inode / resource metadata
For a regular file, the inode holds metadata (owner, permissions, timestamps, block pointers, etc.). The file table entry points to that inode. 

If the FD refers to something else (socket, pipe, device), the file table entry points to the appropriate underlying kernel structure instead. 
Thus, when you call read(fd, buf, n), the kernel:
Looks up fd in your process’s FD table → gets a pointer to the file table entry
From that file table entry, it knows the current offset, access mode, and underlying resource
It does the actual I/O (using the inode, device, or socket)
It updates the offset, handles permissions, etc.

## Directory

## Useful Links

## Tags
