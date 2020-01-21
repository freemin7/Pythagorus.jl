using DataStructures

mutable struct World
    universe::Array{Any,1} # Things to classify
    predicates::Array{Function,1} # Define classes
    reporting::Bool
    agenda::PriorityQueue{Any,Real,Base.Order.ReverseOrdering{Base.Order.ForwardOrdering}}
end

function explore_concepts(W::World)
    while !(isempty(W.agenda))
        current = dequeue!(W.agenda)
        if (W.reporting)
            println(W.agenda.xs)
            println("Calling: $(current[1])($(current[2]),W)")
        end
        #Call unqueued task
        current[1](current[2],W)
    end
end
