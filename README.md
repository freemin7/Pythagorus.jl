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

### Open design questions:
 * Pass predicates as symbol of a function or as it's own type.
 * 
