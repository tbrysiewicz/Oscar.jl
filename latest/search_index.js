var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Welcome to Oscar",
    "title": "Welcome to Oscar",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Welcome-to-Oscar-1",
    "page": "Welcome to Oscar",
    "title": "Welcome to Oscar",
    "category": "section",
    "text": "Oscar is a new computer algebra system under development."
},

{
    "location": "integer.html#",
    "page": "Integers",
    "title": "Integers",
    "category": "page",
    "text": "CurrentModule = Oscar"
},

{
    "location": "integer.html#Integers-1",
    "page": "Integers",
    "title": "Integers",
    "category": "section",
    "text": "An important design decision in Oscar.jl is to use Julia as the user language by default. This means that integers typed at the REPL are Julia integers.For performance reasons, Oscar has its own integer format. These are entered using the ZZ constructor.a = ZZ(2)^100For convenience, many Oscar functions also accept Julia integers as inputs by converting them to Oscar integers, especially if they do not fit in a machine word. For example:R, x = ZZ[\"x\"] # create a polynomial ring over the integers\nf = 2xIn this example, 2 is a Julia integer but is still valid in the call to the Oscar polynomial multiplication function that is implicit in the expression 2x.note: Note\nIn Julia, `2^64` will return `0`, as the Julia integer `2` is a machine\nword. In Oscar, the expression `ZZ(2)^64` will return the correct\nresult (as an Oscar integer). In general, Oscar can only do an\nautomatic conversion to an Oscar integer if the Julia integer is\ncombined with another Oscar expression, or passed to an Oscar function."
},

]}
