""" Combinatorial maps and related structures, as C-sets.

In topological graph theory and graph drawing, an **embedded graph** is a
combinatorial structure representing a graph embedded in an (oriented) surface,
up to equivalence under (orientation-preserving) homeomorphism. This module
defines data structures for rotation systems, combinatorial maps, and other
combinatorial objects describing embedded graphs.
"""
module CombinatorialMaps
export σ, α, ϕ, trace_vertices, trace_edges, trace_faces,
  AbstractRotationGraph, RotationGraph, add_corolla!, pair_half_edges!,
  AbstractRotationSystem, RotationSystem,
  AbstractCombinatorialMap, CombinatorialMap

using Catlab, Catlab.CategoricalAlgebra.CSets, Catlab.Graphs
using Catlab.Graphs.BasicGraphs: TheoryHalfEdgeGraph
using Catlab.Permutations: cycles

# General properties
####################

""" Vertex permutation of combinatorial map or similar structure.
"""
σ(x::AbstractACSet, args...) = subpart(x, args..., :σ)

""" Edge permutation of combinatorial map or similar structure.
"""
α(x::AbstractACSet, args...) = subpart(x, args..., :α)

""" Face permutation of combinatorial map or similar structure.
"""
ϕ(x::AbstractACSet, args...) = subpart(x, args..., :ϕ)

""" Trace vertices of combinatorial map or similar, returning a list of cycles.
"""
trace_vertices(x::AbstractACSet) = cycles(σ(x))

""" Trace edges of combinatorial map or similar, return a listing of cycles.

Usually the cycles will be pairs of half edges but in a hypermap the cycles can
be arbitrary.
"""
trace_edges(x::AbstractACSet) = cycles(α(x))

""" Trace faces of combinatorial map or similar, returning list of cycles.
"""
trace_faces(x::AbstractACSet) = cycles(ϕ(x))

# Rotation graphs
#################

@present TheoryRotationGraph <: TheoryHalfEdgeGraph begin
  σ::Hom(H,H)

  compose(σ, vertex) == vertex
end

const AbstractRotationGraph = AbstractACSetType(TheoryRotationGraph)
const RotationGraph = CSetType(TheoryRotationGraph, index=[:vertex])

α(g::AbstractRotationGraph) = inv(g)
ϕ(g::AbstractRotationGraph) = sortperm(inv(g)[σ(g)]) # == (σ ⋅ inv)⁻¹

""" Add corolla to rotation graph, rotation system, or similar structure.

A *corolla* is a vertex together with its incident half-edges, the number of
which is its *valence*. The rotation on the half-edges is the consecutive one
induced by the half-edge part numbers.
"""
function add_corolla!(g::AbstractRotationGraph, valence::Int; kw...)
  v = add_vertex!(g; kw...)
  n = nparts(g, :H)
  add_parts!(g, :H, valence; vertex=v, σ=circshift((n+1):(n+valence), -1))
end

""" Pair together half-edges into edges.
"""
pair_half_edges!(g::AbstractRotationGraph, h, h′) =
  set_subpart!(g, [h; h′], :inv, [h′; h])

# Rotation systems
##################

@present TheoryRotationSystem(FreeSchema) begin
  H::Ob
  σ::Hom(H,H)
  α::Hom(H,H)

  compose(α, α) == id(H)
end

const AbstractRotationSystem = AbstractACSetType(TheoryRotationSystem)
const RotationSystem = CSetType(TheoryRotationSystem)

# ϕ == (σ⋅α)⁻¹ == α⁻¹ ⋅ σ⁻¹
ϕ(sys::AbstractRotationSystem) = sortperm(α(sys)[σ(sys)])

function add_corolla!(sys::AbstractRotationSystem, valence::Int)
  n = nparts(sys, :H)
  add_parts!(sys, :H, valence; σ=circshift((n+1):(n+valence), -1))
end

pair_half_edges!(sys::AbstractRotationSystem, h, h′) =
  set_subpart!(sys, [h; h′], :α, [h′; h])

# Combinatorial maps
####################

@present TheoryHypermap(FreeSchema) begin
  H::Ob
  σ::Hom(H,H)
  α::Hom(H,H)
  ϕ::Hom(H,H)

  compose(σ, α, ϕ) == id(H)
end

@present TheoryCombinatorialMap <: TheoryHypermap begin
  compose(α, α) == id(H)
end

const AbstractCombinatorialMap = AbstractACSetType(TheoryCombinatorialMap)
const CombinatorialMap = CSetType(TheoryCombinatorialMap)

# TODO: What kind of interface should we have for maps and hypermaps?

end
