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
    "text": "CurrentModule = Oscarusing Oscar"
},

{
    "location": "integer.html#Integers-1",
    "page": "Integers",
    "title": "Integers",
    "category": "section",
    "text": "An important design decision in Oscar.jl is to use Julia as the user language by default. This means that integers typed at the REPL are Julia integers.For performance reasons, Oscar has its own integer format. These are entered using the ZZ constructor.a = ZZ(2)^100For convenience, many Oscar functions also accept Julia integers as inputs by converting them to Oscar integers, especially if they do not fit in a machine word. For example:divexact(ZZ(234), 2)In this example, 2 is a Julia integer but is still valid in the call to divexact because the first argument is an Oscar integer.In general, Oscar can only automatically convert from Julia integers to Oscar integers if they are combined with other Oscar objects or passed to Oscar functions.Oscar integers have the same limitations as GMP multiprecision integers, namely that they are limited by the available memory on the machine and in any case to signed integers whose absolute value does not exceed 2^37 binary bits.In the following, unless stated otherwise, when we refer to integers, we mean Oscar integers. When we refer to an Int we mean the Julia Int.note: Note\nThe Julia Int type is either a 32 or 64 bit integer, depending on    the machine architecture (usually 64 bits on most modern machines). The    range of values is machine dependent, but can be found by typing    typemin(Int) and typemax(Int) in Julia."
},

{
    "location": "integer.html#Basic-arithmetic-1",
    "page": "Integers",
    "title": "Basic arithmetic",
    "category": "section",
    "text": "Oscar provides the basic arithmetic operations +, - and * for integers."
},

{
    "location": "integer.html#Division-1",
    "page": "Integers",
    "title": "Division",
    "category": "section",
    "text": "Oscar distinguishes a number of different kinds of division:Exact division (divexact)\nEuclidean division (div, divrem, rem)\nConstruction of fractions (a//b)\nFloating point division (a/b)\nReciprocals (inv)\nDivisibility testing (divides)These choices have been made for maximum parsimony with the Julia language.note: Note\nIt is a common error to enter `1/2` for the fraction one half in Julia.\nIn the Julia language, this expression is reserved for floating point\ndivision. Instead, the double slash operator is used for fractions.Here we discuss only exact division and inversion/reciprocals. Euclidean division and divisibility testing are discussed below, floating point division is not defined for Oscar integers to avoid confusion, and fractions are discussed on the page for rational numbers.The result of the exact division of two integers will always be another integer. Exact division raises an exception if the division is not exact, or if division by zero is attempted.divexact(ZZ(6), ZZ(3))\ndivexact(ZZ(6), ZZ(0))\ndivexact(ZZ(6), ZZ(5))"
},

{
    "location": "integer.html#Powering-1",
    "page": "Integers",
    "title": "Powering",
    "category": "section",
    "text": "Powering of integers is performed using the caret operator ^. The exponent can be any Julia Int.ZZ(37)^37\nZZ(1)^(-2)note: Note\nAn exception will be raised if an integer outside the range\n    ``[-1, 1]`` is raised to a negative exponent.The following is allowed for convenience.ZZ(0)^0note: Note\nIn Julia, `2^64` will return `0`, as the Julia integer `2` is a machine\nword. In Oscar, the expression `ZZ(2)^64` will return the expected\nresult."
},

]}
