## SLPolyRing (SL = straight-line)

struct SLPolyRing{T<:RingElement,R<:Ring} <: MPolyRing{T}
    base_ring::R
    S::Vector{Symbol}

    SLPolyRing(r::Ring, s::Vector{Symbol}) = new{elem_type(r),typeof(r)}(r, s)
end

SLPolyRing(r::Ring, s::Union{AbstractVector{<:AbstractString},
                             AbstractVector{<:AbstractChar}}) =
                                 SLPolyRing(r, Symbol.(s))

SLPolyRing(r::Ring, n::Base.Integer) = SLPolyRing(r, [Symbol("x$i") for i=1:n])

# cf. mpoly.jl in Oscar
SLPolyRing(r::Ring, v::Pair{<:Union{String,Symbol},
                            <:AbstractVector{<:Base.Integer}}...) =
    SLPolyRing(r, [Symbol(s, n) for (s, ns) in v for n in ns])

base_ring(S::SLPolyRing) = S.base_ring

symbols(S::SLPolyRing) = S.S

# have to constrain T <: RingElement so that this is more specific than the second
# method taking c::RingElement
(S::SLPolyRing{T})(c::T=zero(base_ring(S))) where {T<:RingElement} = S(SLP.Const(c))

(S::SLPolyRing{T})(c::RingElement) where {T<:RingElement} = S(SLP.Const(base_ring(S)(c)))

function gen(S::SLPolyRing{T}, i::Base.Integer) where {T}
    s = symbols(S)[i]
    S(SLP.Gen(s))
end

gens(S::SLPolyRing) = [S(SLP.Gen(s)) for s in symbols(S)]

ngens(S::SLPolyRing) = length(symbols(S))
nvars(S::SLPolyRing) = ngens(S)

# TODO: how to name this function? namespace it?
function SLPolynomialRing(R::Ring, s)
    S = SLPolyRing(R, s)
    S, gens(S)
end

function SLPolynomialRing(R::Ring, v::Pair{<:Union{String,Symbol},
                                         <:AbstractVector{<:Base.Integer}}...)
    S = SLPolyRing(R, v...)

    # TODO: enable on Julia 1.5 (required for init keyword)
    # rs = Iterators.accumulate(v; init=0:0) do x, a
    #     last(x)+1:last(x)+length(a[2])
    # end
    rs = []
    prev = 0
    for a in v
        newprev = prev+length(a[2])
        push!(rs, prev+1:newprev)
        prev = newprev
    end

    gs = gens(S)
    S, (gs[r] for r in rs)...
end

Base.one(S::SLPolyRing) = S(one(base_ring(S)))
Base.zero(S::SLPolyRing) = S()

# TODO: merge this with method in AbstractAlgebra
function Base.show(io::IO, p::SLPolyRing)
    max_vars = 5
    n = nvars(p)
    print(io, "SLP Multivariate Polynomial Ring in ")
    if n > max_vars
        print(io, n)
        print(io, " variables ")
    end
    for i = 1:min(n - 1, max_vars - 1)
        print(io, string(p.S[i]), ", ")
    end
    if n > max_vars
        print(io, "..., ")
    end
    print(io, string(p.S[n]))
    print(io, " over ")
    print(IOContext(io, :compact => true), base_ring(p))
end



## SLPoly

struct SLPoly{T<:RingElement,SLPR<:SLPolyRing{T}} <: MPolyElem{T}
    parent::SLPR
    slprogram::SLProgram{T}

    SLPoly(parent, slp::SLProgram) =
        new{elem_type(base_ring(parent)),typeof(parent)}(parent, slp)
end

SLP.constants(p::SLPoly) = SLP.constants(p.slprogram)
SLP.lines(p::SLPoly) = SLP.lines(p.slprogram)


# create invalid poly
SLPoly(parent::SLPolyRing{T}) where {T} = SLPoly(parent, SLProgram{T}())

isvalid(p::SLPoly) = !SLP.hasmultireturn(p.slprogram)

function assert_valid(p::SLPoly)
    isvalid(p) || throw(ArgumentError("SLPoly is in an invalid state"))
    p
end

parent(p::SLPoly) = p.parent

function check_parent(p::SLPoly, q::SLPoly)
    p.parent === q.parent ||
        throw(ArgumentError("incompatible parents"))
    p.parent
end

function (S::SLPolyRing{T})(p::SLPoly{T}) where T <: RingElement
    parent(p) != S && throw(ArgumentError("unable to coerce polynomial"))
    p
end

Base.zero(p::SLPoly) = zero(parent(p))
Base.one(p::SLPoly) = one(parent(p))

function Base.copy!(p::SLPoly{T}, q::SLPoly{T}) where {T}
    check_parent(p, q)
    copy!(p.slprogram, q.slprogram)
    p
end

function Base.copy(q::SLPoly)
    p = SLPoly(q.parent)
    copy!(p, q)
    p
end

"""
    nsteps(p::SLPoly)

Return the number of steps ("lines") involved in the underlying
straight-line program.
"""
SLP.nsteps(p::SLPoly) = SLP.nsteps(p.slprogram)


## show

function Base.show(io::IO, p::SLPoly)
    io = IOContext(io, :SLPsymbols => symbols(parent(p)))
    show(io, p.slprogram)
end


## mutating ops

SLP.pushinit!(p::SLPoly) = SLP.pushinit!(p.slprogram)

function SLP.pushfinalize!(p::SLPoly, i)
    SLP.pushfinalize!(p.slprogram, i)
    p
end

SLP.pushop!(p::SLPoly, op::SLP.Op, i::SLP.Arg, j::SLP.Arg=SLP.Arg(0)) =
    SLP.pushop!(p.slprogram, op, i, j)

function SLP.combine!(op::SLP.Op, p::SLPoly, q::SLPoly)
    SLP.combine!(op, p.slprogram, q.slprogram)
    p
end

addeq!(p::SLPoly{T}, q::SLPoly{T}) where {T} = SLP.combine!(SLP.plus, p, q)

SLP.subeq!(p::SLPoly{T}, q::SLPoly{T}) where {T} = SLP.combine!(SLP.minus, p, q)

function SLP.subeq!(p::SLPoly)
    SLP.combine!(SLP.uniminus, p.slprogram)
    p
end

SLP.muleq!(p::SLPoly{T}, q::SLPoly{T}) where {T} = SLP.combine!(SLP.times, p, q)

function SLP.expeq!(p::SLPoly, e::Base.Integer)
    SLP.combine!(SLP.exponentiate, p.slprogram, e)
    p
end

function permutegens!(p::SLPoly, perm)
    SLP.permute_inputs!(p.slprogram, perm,
                        perm isa Union{AbstractArray,AbstractAlgebra.AbstractPerm})
    p
end


## unary/binary ops

+(p::SLPoly{T}, q::SLPoly{T}) where {T} = addeq!(copy(p), q)

*(p::SLPoly{T}, q::SLPoly{T}) where {T} = SLP.muleq!(copy(p), q)

-(p::SLPoly{T}, q::SLPoly{T}) where {T} = SLP.subeq!(copy(p), q)

-(p::SLPoly) = SLP.subeq!(copy(p))

^(p::SLPoly, e::Base.Integer) = SLP.expeq!(copy(p), e)

# should be AbstractPerm instead of GroupElem, but we need to support GAP's
# permutations as provided in Oscar
^(p::SLPoly, perm::AbstractAlgebra.GroupElem) = permutegens!(copy(p), perm)


## adhoc ops

+(p::SLPoly{T}, q::T) where {T<:RingElem} = p + parent(p)(q)
+(q::T, p::SLPoly{T}) where {T<:RingElem} = parent(p)(q) + p

-(p::SLPoly{T}, q::T) where {T<:RingElem} = p - parent(p)(q)
-(q::T, p::SLPoly{T}) where {T<:RingElem} = parent(p)(q) - p

*(p::SLPoly{T}, q::T) where {T<:RingElem} = p * parent(p)(q)
*(q::T, p::SLPoly{T}) where {T<:RingElem} = parent(p)(q) * p


## comparison

# TODO: two SLPolys migth be considered equal if they "canonical" form
# would be equal (e.g. their conversions to MPoly)
function Base.:(==)(p::SLPoly{T}, q::SLPoly{T}) where {T}
    check_parent(p, q)
    p.slprogram == q.slprogram
end


## evaluate

evaluate(p::SLPoly{T}, xs::Vector{S}, conv::F=identity
         ) where {T<:RingElement,S<:RingElement,F} =
             SLP.evaluate(p.slprogram, xs, conv)

function SLP.evaluate!(res::Vector{S}, p::SLPoly{T}, xs::Vector{S},
                       conv::F=identity
                       ) where {S,T,F}
    SLP.evaluate!(res, p.slprogram, xs, conv)
end


## conversion Lazy -> SLP

(R::SLPolyRing{T})(p::LazyPoly{T}) where {T} = R(p.p)

# TODO: remove this method (this is an ambiguity fix)
(R::SLPolyRing{T})(p::LazyPoly{T}) where {T<:RingElement} = R(p.p)

function (R::SLPolyRing{T})(p::SLP.LazyRec) where {T}
    pr = SLP.compile(SLProgram{T}, p, symbols(R))
    SLPoly(R, pr)
end


## conversion MPoly -> SLPoly

function Base.convert(R::SLPolyRing, p::Generic.MPoly; limit_exp::Bool=false)
    # TODO: currently handles only default ordering
    symbols(R) == symbols(parent(p)) ||
        throw(ArgumentError("incompatible symbols"))
    q = SLPoly(R)
    @assert lastindex(p.coeffs) < SLP.cstmark
    qcs = SLP.constants(q)
    @assert isempty(qcs)
    # have to use p.length, as p.coeffs and p.exps
    # might contain trailing gargabe
    resize!(qcs, p.length)
    copyto!(qcs, 1, p.coeffs, 1, p.length)
    exps = UInt64[]
    monoms = [Pair{UInt64,SLP.Arg}[] for _ in axes(p.exps, 1)]
    for v in reverse(axes(p.exps, 1))
        copy!(exps, view(p.exps, v, 1:p.length))
        unique!(sort!(exps))
        if !isempty(exps) && first(exps) == 0
            popfirst!(exps)
        end
        isempty(exps) && continue
        xref = SLP.input(size(p.exps, 1) + 1 - v)
        if limit_exp # experimental
            # TODO: move to a general SLP optimization pass?
            # and check in which case it's an improvement

            # 1) find all exponents which will be computed, i.e. all e÷2
            # for all e in exps, recursively
            n = length(exps) - 1
            while length(exps) > n
                n = length(exps)
                for i in eachindex(exps)
                    exps[i] == 1 && continue
                    e0 = exps[i] >> 1
                    push!(exps, e0)
                end
                unique!(sort!(exps))
            end

            # 2) for all e from 1), compute x^2 and store the result in monoms
            for e in exps
                e1 = e >> 1
                if e == 1
                    k = xref
                elseif monoms[v][end][1] == 2*e1
                    @assert e == 2*e1+1
                    k = SLP.pushop!(q, SLP.times, monoms[v][end][2], xref)
                else
                    m1 = searchsortedfirst(monoms[v], e1, by=first)
                    k1 = monoms[v][m1][2]
                    k = SLP.pushop!(q, SLP.times, k1, k1)
                    if e1+e1 != e
                        @assert e1+e1+1 == e
                        k = SLP.pushop!(q, SLP.times, k, xref)
                    end
                end
                push!(monoms[v], e => k)
            end
        else
            for e in exps
                e == 0 && continue
                k = SLP.pushop!(q, SLP.exponentiate, xref, SLP.Arg(e))
                push!(monoms[v], e => k)
            end
        end
    end

    k = SLP.Arg(0) # TODO: don't use 0
    for t in eachindex(qcs)
        i = SLP.asconstant(t)
        j = 0
        for v in reverse(axes(p.exps, 1))
            e = p.exps[v, t]
            if  e != 0
                j = monoms[v][searchsortedfirst(monoms[v], e, by=first)][2]
                i = SLP.pushop!(q, SLP.times, i, j)
            end
        end
        if k == SLP.Arg(0)
            k = i
        else
            k = SLP.pushop!(q, SLP.plus, k, i)
        end
    end
    if isempty(qcs)
        k = SLP.pushconst!(q.slprogram, base_ring(R)())
    end
    SLP.pushfinalize!(q, k)
    q
end


## conversion SLPoly -> MPoly

function Base.convert(R::MPolyRing, p::SLPoly)
    symbols(R) == symbols(parent(p)) ||
        throw(ArgumentError("incompatible symbols"))
    assert_valid(p)
    evaluate(p, gens(R))
end


## compile!

SLP.compile!(p::SLPoly) = SLP.compile!(p.slprogram)