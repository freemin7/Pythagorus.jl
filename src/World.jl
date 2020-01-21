mutable struct World
    universe::Any #Tuple{Symbol}
    predicates::Any #Tuple{Symbol}
    reporting::Bool
    agenda::Any
    concept_counter::Int64
end
