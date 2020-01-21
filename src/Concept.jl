struct Concept
    id::Symbol
    defn::String
    predicate::Function
    interest::Float64
    objects-to-try::Tuple
    example-found::Tuple
    unused-predicates::Tuple
    predicates-used-in-spec::Tuple
    predicates-used-in-desc::Tuple
    number-found::Int64
    number-tried::Int64
    parent::Union{Concept, Missing}
    subconcepts::Tuple{Concept}
end
