module TestSimplicialSets
using Test

using Catlab.CategoricalAlgebra.CSets
using CombinatorialSpaces.SimplicialSets

""" Check that the semi-simplicial identities hold in dimension `n`.
"""
function is_semi_simplicial(s::AbstractACSet, n::Int)
  @assert n >= 2
  ∂, ∂′ = (∂₁, ∂₂)[[n, n-1]]
  for i in 1:n, j in (i+1):n
    ∂′(s, i, ∂(s, j)) == ∂′(s, j-1, ∂(s, i)) || return false
  end
  return true
end

# 1D simplicial sets
####################

s = SemiSimplicialSet1D()
add_vertices!(s, 4)
add_sorted_edge!(s, 2, 1)
add_sorted_edges!(s, [2,4], [3,3])
@test src(s) == [1,2,3]
@test tgt(s) == [2,3,4]
@test ∂₁(s, 0) == [2,3,4]
@test ∂₁(s, 1) == [1,2,3]

# 2D simplicial sets
####################

s = SemiSimplicialSet2D()
add_vertices!(s, 3)
glue_triangle!(s, 1, 2, 3)
@test is_semi_simplicial(s, 2)
@test ntriangles(s) == 1
@test map(i -> ∂₂(s, i, 1), (0,1,2)) == (2,3,1)
@test map(i -> triangle_vertex(s, i, 1), (0,1,2)) == (1,2,3)

s′ = SemiSimplicialSet2D()
add_vertices!(s′, 3)
glue_sorted_triangle!(s′, 2, 3, 1)
@test s′ == s

# Triangulation of commutative square.
s = SemiSimplicialSet2D()
add_vertices!(s, 4)
glue_triangle!(s, 1, 2, 3)
glue_triangle!(s, 1, 4, 3)
@test ntriangles(s) == 2
@test triangles(s) == 1:2
@test ne(s) == 5
@test sort(map(Pair, src(s), tgt(s))) == [1=>2, 1=>3, 1=>4, 2=>3, 4=>3]

end
