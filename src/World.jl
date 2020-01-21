mutable struct World
    universe::Any #Tuple{Symbol}
    predicates::Tuple
    reporting::Bool
    agenda::Any
    concept_counter::Int64
end
