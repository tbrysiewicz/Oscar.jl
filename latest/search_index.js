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
    "text": "CurrentModule = Oscarusing OscarPages = [\"integers.md\"]"
},

{
    "location": "integer.html#Integers-1",
    "page": "Integers",
    "title": "Integers",
    "category": "section",
    "text": "An important design decision in Oscar.jl is to use Julia as the user language by default. This means that integers typed at the REPL are Julia integers. However, for performance reasons, Oscar has its own integer format.In the following, unless stated otherwise, when we refer to integers we mean Oscar integers; when we refer to an Int we mean the Julia Int."
},

{
    "location": "integer.html#Constructors-1",
    "page": "Integers",
    "title": "Constructors",
    "category": "section",
    "text": "Oscar integers are created using the ZZ constructor.ZZ(2)^100\nZZ(618970019642690137449562111)"
},

{
    "location": "integer.html#Julia-integers-in-Oscar-functions-1",
    "page": "Integers",
    "title": "Julia integers in Oscar functions",
    "category": "section",
    "text": "For convenience, many Oscar functions also accept Julia integers. For example:divexact(ZZ(234), 2)In this example, 2 is a Julia integer but is still valid in the call to the Oscar function divexact.In general, Oscar can only automatically convert from Julia integers to Oscar integers if they are combined with other Oscar objects or passed to Oscar functions."
},

{
    "location": "integer.html#Limitations-1",
    "page": "Integers",
    "title": "Limitations",
    "category": "section",
    "text": "Oscar integers have the same limitations as GMP multiprecision integers, namely that they are limited by the available memory on the machine and in any case to signed integers whose absolute value does not exceed 2^37 bits.note: Note\nThe Julia \'Int\' type is either a 32 or 64 bit integer, depending on the machine architecture (usually 64 bits on most modern machines). The range of values is machine dependent, but can be found by typing \'typemin(Int)\' and \'typemax(Int)\' in Julia."
},

{
    "location": "integer.html#Basic-functionality-1",
    "page": "Integers",
    "title": "Basic functionality",
    "category": "section",
    "text": "Oscar provides the following basic functions for the ring of integers:zero(ZZ) - return the integer 0\none(ZZ) - return the integer 1There are also the following predicates for integers n:iszero(n) - n = 0\nisone(n) - n = 1\nisunit(n) - n = pm 1The following functions are also provided.sign(n) returns the sign of n, i.e. nn if n neq 0 or0 otherwise.sign(ZZ(23))\nsign(ZZ(0))\nsign(ZZ(-1))"
},

{
    "location": "integer.html#Basic-arithmetic-1",
    "page": "Integers",
    "title": "Basic arithmetic",
    "category": "section",
    "text": "Oscar provides the basic arithmetic operations +, - and * and comparison operators ==, !=, <, <=, >, >=, including mixed operations between Julia and Oscar integers. It also provides division and powering as described below."
},

{
    "location": "integer.html#Division-in-Oscar-1",
    "page": "Integers",
    "title": "Division in Oscar",
    "category": "section",
    "text": "Oscar distinguishes a number of different kinds of division:Exact division (divexact)\nEuclidean division (div, divrem, mod, rem)\nConstruction of fractions (a//b)\nFloating point division (a/b)\nDivisibility testing (divides)These choices have been made for maximum parsimony with the Julia language.note: Note\nIt is a common error to enter \'1/2\' for the fraction \'one half\' in Julia. This expression is reserved for floating point division. Instead, the double slash operator \'//\' should be used for fractions."
},

{
    "location": "integer.html#integer_exact_division-1",
    "page": "Integers",
    "title": "Exact Division",
    "category": "section",
    "text": "Exact division is carried out using the divexact function.The result of the exact division of two integers will always be another integer. Exact division raises an exception if the division is not exact, or if division by zero is attempted.divexact(ZZ(6), ZZ(3))\ndivexact(ZZ(6), ZZ(0))\ndivexact(ZZ(6), ZZ(5))"
},

{
    "location": "integer.html#Powering-1",
    "page": "Integers",
    "title": "Powering",
    "category": "section",
    "text": "Powering of integers is performed using the caret operator ^. The exponent can be any Julia Int.ZZ(37)^37\nZZ(1)^(-2)note: Note\nAn exception will be raised if an integer outside the range [-1, 1] is raised to a negative exponent.The following is allowed for convenience.ZZ(0)^0note: Note\nIn Julia, \'2^64\' will return 0, as the Julia integer 2 is a machine word. In Oscar, the expression \'ZZ(2)^64\' will return the expected result."
},

{
    "location": "integer.html#integer_euclidean_division-1",
    "page": "Integers",
    "title": "Euclidean division",
    "category": "section",
    "text": "The ring of integers is a Euclidean domain and Oscar provides Euclidean division.The divrem function returns both quotient and remainder, whilst div returns just the quotient and mod returns just the remainder.The remainder is taken to be the least non-negative residue, i.e. if a and m are integers, Euclidean division in Oscar finds a quotient q and remainder r such that a = qm + r where 0 leq r  m.q, r = divrem(ZZ(5), ZZ(-3))\nq = div(ZZ(7), ZZ(2)\nr = mod(ZZ(4), ZZ(3)note: Note\nThe results of divrem, div and mod do not agree with their namesakes in Julia when the modulus m is negative."
},

{
    "location": "integer.html#integer_divisibility_testing-1",
    "page": "Integers",
    "title": "Divisibility testing",
    "category": "section",
    "text": "Divisibility testing is performed using the divides function.In Oscar, we say that b divides a if there exists c in the same ring such that a = bc.The call divides(a, b) returns a tuple (flag, q) where flag is either true if b divides a in which case q will be a quotient, or flag is false if b does not divide a and q will be an integer whose value is not defined.divides(ZZ(6), ZZ(3))\ndivides(ZZ(5), ZZ(2))Note that for convenience we define:divides(ZZ(0), ZZ(0))"
},

]}
