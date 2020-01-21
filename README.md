# Pythagorus
#### "Pythagoras" -- a program that demonstrates heuristically-guided concept formation in mathematics.
(C) Copyright 1995 by Steven L. Tanimoto.
This program is described in Chapter 10 ("Learning") of "The Elements of Artificial Intelligence Using Common Lisp," 2nd ed., published by W. H. Freeman, 41 Madison Ave., New York, NY 10010. Permission is granted for noncommercial use and modification of this program, provided that this copyright notice is retained and followed by a notice of any modifications made to the program.
#### Changes
Pythagorus is a port `PYTHAG.CL` to Julia.
The program is split in to different files
 * `Concept.jl` defines the Concept type and gives explicit type info
 * `World.jl` defines the type of a global singleton to encapsulate global `*earmuff*` state.
 * `test/provided_example.jl` contains all the "content" from the orignal.
 * maybe bugs in the interest calculation
 * a skeleton of a test suite which is based around the original example

### Usage
Define a world object, use it to define a Concept with a catch-all predicate. Schedule a `find_examples_of` and a `make_specialization` on it using the agenda PriorityQueue in the world object. Then call `explore_concepts` on the world object.
This algorithm makes no assumptions about the objects in it's universe other than they are printable.
Each predicate maps each object from the universe to a boolean. These predicates and their combinations with `&` are used to classify all objects.

### Why?
Pythagoras is a minimal implentation of the principles behind [AM](https://en.wikipedia.org/wiki/Automated_Mathematician).
I wanted to evaluate Julia for heuristic-based, symbolic AI. The fact that this repo is tagged as Common Lisp demonstrates that Julia is more compact for such simple systems. This is also since the example is not self contained and can draw on the great eco-system of Julia. 
