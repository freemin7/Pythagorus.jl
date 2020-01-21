using Pythagorus
using Test

include("provided_example.jl")

@test length(Object.example_found)==0
@test length(Object.objects_to_try)==10
@test length(Object.unused_predicates)==3

explore_concepts(Singleton)

@test length(Object.example_found)==10
@test length(Object.objects_to_try)==0

## to lazy to write a proper test.
