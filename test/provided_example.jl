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
    name::Symbol
    edges::T
end

universe = [Polygon(:box,(P(0.0,0.0),P(0.0,5.0),P(10.0,5.0),P(10.0,0.0))),
            Polygon(:square,(P(0.0,0.0),P(0.0,10.0),P(10.0,10.0),P(10.0,0.0))),
            Polygon(:isosceles,(P(0.0,0.0),P(5.0,5.0),P(10.0,0.0))),
            Polygon(:right_triangle,(P(0.0,0.0),P(4.0,3.0),P(4.0,0.0))),
            Polygon(:trapezoid,(P(0.0,0.0),P(5.0,5.0),P(20.0,5.0),P(25.0,0.0))),
            Polygon(:parallelogram,(P(0.0, 0.0), P(5.0, 5.0), P(15.0, 5.0), P(10.0, 0.0))),
            Polygon(:rhombus,(P(0.0, 0.0), P(4., 3.), P(9., 3.), P(5., 0.))),
            Polygon(:multi,(P(0., 0.), P(0., 10.), P(4., 15.), P(10., 15.), P(15., 10.), P(15., 4.), P(10., 0.) )),
            Polygon(:line,(P(0.0,0.0),P(10.0,0.0))),
            Polygon(:dot,(P(0.0,0.0),))]




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

predicates = [many_sides,nonzero_area,equal_sides]

reporting = false
agenda = PriorityQueue{Any,Float64}(Base.Order.Reverse);

Singleton = World(universe,predicates,reporting,agenda)
