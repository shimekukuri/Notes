# C Sharp Concepts - Linq

## Abstract
LINQ (Language Integrated Query) is a set of features in C# that allows you to query, filter, and transform data from
different sources using a single, unified syntax. Instead of writing different code for a SQL database, an XML file,
or a simple List<T>, LINQ lets you use the same C# commands for all of them.

Core Concepts
Unified Syntax: You don't need to learn separate languages for different data types; you use C# for everything.
Strong Typing: Queries are checked at compile-time, meaning you get IntelliSense support and fewer runtime crashes.
Deferred Execution: Most LINQ queries don't actually run when you define them. They only execute when you
"materialize" the data (e.g., using a foreach loop or calling .ToList()).

The Two Syntax Styles
There are two ways to write LINQ. They are functionally identical, but most developers prefer Method Syntax for
its flexibility.

Feature 	Query Syntax	Method Syntax
Appearance	Similar to SQL (from, where, select)	Chained methods with lambda expressions
Example	from x in list where x > 5 select x	list.Where(x => x > 5)
Best For	Complex joins and groupings	Most daily tasks and simple filters

Common LINQ Methods
Where: Filters the collection based on a condition.
Select: Transforms each element into a new form (projection).
OrderBy: Sorts the elements in ascending or descending order.
Any / All: Checks if any (or all) elements meet a specific condition.
First / FirstOrDefault: Retrieves the first item that matches a condition.
ToList / ToArray: Forces the query to execute immediately and stores the result in a collection.

Why Use It?
Before LINQ, you would often need multiple foreach loops and if statements to find a specific item in a list. LINQ
collapses those 10 lines of "boilerplate" code into a single, readable line.

Would you like to see a real-world example of how to refactor a standard foreach loop into a LINQ query?

## Directory

## Useful Links

## Tags
