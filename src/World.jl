using DataStructures

mutable struct World
    universe::Array{Any,1}
    predicates::Array{Function,1}
    reporting::Bool
    agenda::PriorityQueue{Any,Float64,Base.Order.ReverseOrdering{Base.Order.ForwardOrdering}}
end
