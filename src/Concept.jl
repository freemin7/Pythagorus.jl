struct Concept
    id::Symbol
    defn::String
    predicate::Function
    interest::Float64
    objects_to_try::Tuple
    example_found::Tuple
    unused_predicates::Tuple
    predicates_used_in_spec::Tuple
    predicates_used_in_desc::Tuple
    number_found::Int64
    number_tried::Int64
    parent::Union{Concept, Missing}
    subconcepts::Tuple{Concept}
end
