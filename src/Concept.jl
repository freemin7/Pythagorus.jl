mutable struct Concept
    id::Symbol
    defn::String
    predicate::Function
    interest::Float64
    objects_to_try::Array
    example_found::Array
    unused_predicates::Array
    predicates_used_in_spec::Array
    predicates_used_in_desc::Array
    number_found::Int64
    number_tried::Int64
    parent::Union{Concept, Missing}
    subconcepts::Array{Concept}
    function Concept(W::World,Desc,pred,intr,spec::Array,desc::Array,par,subc)
        new(gensym(),
            Desc,
            pred,
            intr,
            copy(W.universe),
            [],
            copy(W.predicates),
            spec,
            desc,
            0,
            0,
            par,
            subc)
    end
end

function Base.show(io::IO,  P::Concept)
    print(io, P.defn)
end

"""
    make_specialization(C::Concept,W::World)

    ; A task of type MAKE-SPECIALIZATION requires that the system
    ;  attempt to create a representation for a new concept.
    ; To create a new concept, the function MAKE-SPECIALIZATION
    ;  creates a structure containing  the following:
    ; - A unique id which is a symbol, e.g., C1, C2, etc.
    ; - A definition of the concept in terms of the parent concept.
    ;   suitable for an explanatory printout.
    ; - A predicate that can be applied to any object
    ;   to determine whether it is an example of this concept.
    ; - An interest value for the concept computed using a rule
    ;   which takes into account the interest of the parent concept
    ;   and the interest of the predicate used to form the restriction.
    ; - A list of objects that have not yet been tried as possible examples,
    ;   initially the whole "UNIVERSE".
    ; - A list of examples found.
    ; - A list of the predicates NOT used in the definition of this concept -
    ;   this simplifies the procedure MAKE-SPECIALIZATION.
    ; - A list of the original (provided) predicates that have been used
    ;   along the path from OBJECT to this concept (used in DISPLAY-CONCEPTS).
    ; - A list of the predicates that have been used to create specializations
    ;   of this concept.
    ; - The number of examples found (so far).
    ; - The number of objects tried (so far).
    ; - A parent concept.
    ; - A list of subconcepts.
    ; These items are put on the property list of the atom under the
    ; types: ID, DEFN, PREDICATE, INTEREST, OBJECTS-TO-TRY, EXAMPLES-FOUND,
    ;	UNUSED-PREDICATES, PREDICATES-USED-IN-SPEC,
    ;	PREDICATES-USED-IN-DESC, NUMBER-FOUND, NUMBER-TRIED,
    ;       PARENT, SUBCONCEPTS.
"""
function make_specialization(C::Concept,W::World)
    unused_pred = setdiff(C.unused_predicates,C.predicates_used_in_spec)
    # Select a predicate not already involved in the parent
    # and not already used for a specialization of C.

    if isempty(unused_pred)
        print("Cannot further specialize concept $C")
        return missing ##TODO maybe false? not sure
    end
    pred = first(unused_pred)

    #Indicate that the selected predicate is no longer available
    push!(C.predicates_used_in_spec,pred)

    #Create a new concept structure
    newc = Concept(
        W,
        #Formulate the definition
        "$(C.defn) with $pred",
        #Create the predicate which tests an object to see if
        #it is an example of the new concept:
        (x)->(C.predicate(x) & pred(x)),
        #interest = interest of parent concept.
        C.interest,
        #inherit specializations used from parent
        #not so in original code
        copy(C.predicates_used_in_spec),
        push!(copy(C.predicates_used_in_desc),pred),
        #parent is C
        C,
        #no childreen yet
        []
        )
        push!(C.subconcepts,newc)

        println("Created $(newc.id): $(newc.defn)")
    if !(haskey(W.agenda,(find_examples_of,newc)))
        enqueue!(W.agenda,(find_examples_of,newc)=>C.interest)
    end
    if !(haskey(W.agenda,(make_specialization,C)))
        enqueue!(W.agenda,(make_specialization,C)=>spec_task_interest(C))
    end

    newc.unused_predicates=filter((x)->(x!=pred),C.unused_predicates)
end



"""
    find_examples_of(C::Concept)

    Tests objects for being examples of concept C, and updates
    the agenda according to the findings

;;; To find examples, the procedure FIND-EXAMPLES-OF takes the list of
;;; objects not yet tried and tries a fixed number of them, (3 of them).
;;; It puts any examples found on the list of examples for the concept,
;;; and it updates the list of objects left to try.
;;; This procedure also does the following:
;;; It updates the interest value for the concept in accordance to
;;; the results of looking for examples.
"""
function find_examples_of(C::Concept,W::World)
    n = min(3,length(C.objects_to_try))
    for i=1:1:n
        C.number_tried += 1;
        x, C.objects_to_try = C.objects_to_try[1],C.objects_to_try[2:end]

        if (C.predicate(x))
            println("$x is an example of $(C.id)")
            C.number_found += 1;
            push!(C.example_found,x)
        else
            println("$x is not an example of $(C.id)")
        end
    end

    # The example-checking part of this task is over.
    # Now update the interest value for C:

    C.interest = compute_concept_interest(C)

    # If there are still objects not yet tried, enter a new
    # task on the agenda to try 3 more objects.

    if !(isempty(C.objects_to_try)) & !(haskey(W.agenda,(find_examples_of,C)))
        enqueue!(W.agenda,(find_examples_of,C)=>examples_task_interest(C))
    else
        if (W.reporting)
            print("All objects are tested for $(C.id)")
        end
    end
    # If there is at least one example of the concept and no
    # specializations for this concept have yet been created,
    # and no tasks for such specialization are already on the
    # agenda, create a new task to make a specialization of C:

    if (C.number_found>0 &
        isempty(C.subconcepts) )

        if (W.reporting)
            println((make_specialization,C))
        end
        if !(haskey(W.agenda,(make_specialization,C)))
            enqueue!(W.agenda,(make_specialization,C)=>spec_task_interest(C))
        end
    end
end


"""
    compute_concept_interest(C)

    ;;; CONCEPT-INTEREST computes the current interest value
    ;;; for concept C using a formula that involves the hit ratio.
"""
function compute_concept_interest(C)
    if C.number_tried == 0
        if (ismissing(C.parent))
            error("Can't compute interest for $C")
        else
            return C.parent.interest
        end
    else
        r = C.number_found / C.number_tried
        return 400.0 * (r-r^2)
    end
end

"""
    examples_task_interest(C::Concept)

    ;;; EXAMPLES-TASK-INTEREST computes the interest of a task to
    ;;; find examples of C as a weighted sum of the interests of
    ;;; C and it parent.
"""
function examples_task_interest(C::Concept)
    if (ismissing(C.parent))
        return 50
    else
        return C.parent.interest*0.8+0.2*C.interest
    end
end

"""
    spec_task_interest(C::Concept)

    ;;; SPEC-TASK-INTEREST computes the interest value
    ;;; for a specialization task, according to the formula:
    ;;;  value = 10 times the parent's hit ratio.
    ;;; We add one to the denominator to avoid the possibility
    ;;; of division by zero.
"""
function spec_task_interest(C::Concept)
    return (10*C.number_found)/(1 + C.number_tried)
end
