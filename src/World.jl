using DataStructures

mutable struct World
    universe::Array{Any,1}
    predicates::Array{Function,1}
    reporting::Bool
    agenda::PriorityQueue{Any,Float64,Base.Order.ReverseOrdering{Base.Order.ForwardOrdering}}
end

function explore_concepts(W::World)
    while !(isempty(W.agenda))
        current = dequeue!(W.agenda)
        if (W.reporting)
            println(W.agenda.xs)
            println("Calling: $(current[1])($(current[2]),W)")
        end
        current[1](current[2],W)
    end
end
