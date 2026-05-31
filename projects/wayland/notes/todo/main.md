# Juniper - Todo

## Abstract

- Need to impliment logging
- Setup fuzzing

## Worked on
May 30: 
In order for me to insert into Global into the registries data ( Soa Of Global ) I need to ammend SOA so that it can take an enum value

May 31: 
Refer To SOA Todo list 1. Enable Enums for current status
It currently appears that we can successfully insert the registry values into the Soa that exists inside of the Regsitry service. lets try 
and log it back out...
Yeah there is problems with actually formatting which are kind of not even really relevent to what I am trying to do

Leaving on this note Test for Querying on an enum value is not working this is the next thing for us to tackle. 
  ~/Code/zig/Juniper ❯ zig test ./src/utility/AlignedStructOfArrays.zig
src/utility/AlignedStructOfArrays.zig:304:33: error: reached unreachable code
                                unreachable;
                                ^~~~~~~~~~~
referenced by:
    test.Can Query With Enum: src/utility/AlignedStructOfArrays.zig:685:26

Compile Log Output:
@as(type, [1024]AlignedStructOfArrays.test.Can Query With Enum.ExampleEnum)


## Directory

## Useful Links

## Tags
