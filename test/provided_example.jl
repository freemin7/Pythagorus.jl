struct P{T<:Real}
    x::T
    y::T
end

import Base.+, Base.-
function +(A::P,B::P)
 return P(A.x+B.x,A.y+B.y)
end
function -(A::P,B::P)
 return P(A.x-B.x,A.y-B.y)
end

using LinearAlgebra
import LinearAlgebra.norm
function norm(P::P)
    sqrt(P.x^2+P.y^2)
end

struct Polygon{T}
    edges::T
end

box = Polygon((P(0.0,0.0),P(0.0,5.0),P(10.0,5.0),P(10.0,0.0)))
square = Polygon((P(0.0,0.0),P(0.0,10.0),P(10.0,10.0),P(10.0,0.0)))
isosceles = Polygon((P(0.0,0.0),P(5.0,5.0),P(10.0,0.0)))
right_triangle = Polygon((P(0.0,0.0),P(4.0,3.0),P(4.0,0.0)))
trapezoid = Polygon((P(0.0,0.0),P(5.0,5.0),P(20.0,5.0),P(25.0,0.0)))
parallelogram = Polygon((P(0.0, 0.0), P(5.0, 5.0), P(15.0, 5.0), P(10.0, 0.0)))
rhombus = Polygon((P(0.0, 0.0), P(4., 3.), P(9., 3.), P(5., 0.)))
multi = Polygon((P(0., 0.), P(0., 10.), P(4., 15.), P(10., 15.), P(15., 10.), P(15., 4.), P(10., 0.) ))
line = Polygon((P(0.0,0.0),P(10.0,0.0)))
dot = Polygon((P(0.0,0.0),))

universe = (:box,:square,:isosceles,:right_triangle,:trapezoid,
    :parallelogram,:rhombus,:multi,:line,:dot)

"""
    many_sides(P::Polygon)

Returns T if P has more than 6 sides.
"""
function many_sides(P::Polygon)
    return length(P.edges) > 6;
end

"""
    nonzero_area(P::Polygon)

Returns T if P has nonzero area.
"""
function nonzero_area(P::Polygon)
    return area(P)!=0
end # function

"""
    area(P::Polygon)

    Computes the area enclosed by polygon P.
    Taken from https://rosettacode.org/wiki/Shoelace_formula_for_polygonal_area#Kotlin
"""
function area(P::Polygon)
    n = length(P.edges)
    a = 0.0
    for i in range(1,stop=n-1)
        a+= P.edges[i].x * P.edges[i+1].y - P.edges[i+1].x * P.edges[i].y
    end
    return abs(a + P.edges[n].x * P.edges[1].y - P.edges[1].x * P.edges[n].y) / 2.0
end # function

"""
    equal_sides(P::Polygon)

EQUAL-SIDES is true if all sides of P have equal length
"""
function equal_sides(P::Polygon)
    n = length(P.edges)
    len = norm(P.edges[1]-P.edges[n])
    for i=1:n-1
        if norm(P.edges[i]-P.edges[i+1]) != len
            return false
        end
    end
    return true
end # function

predicates = (:many_sides,:nonzero_area,:equal_sides)

reporting = false
agenda = ();
concept_counter = 0;

Singleton = World(universe,predicates,reporting,agenda,concept_counter)
