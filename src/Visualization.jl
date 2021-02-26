""" Visualization for Delta Sets and their duals.

This module provides wrapper functions for plotting embedded delta sets
using the Makie functionality. This includes the wireframe, mesh, and scatter
plotting functions.

It is important to note that the end-user will need to import one of the Makie
backends (CairoMakie, GLMakie, or WGLMakie) in order for plotting to work
correctly.
"""

module Visualization

using Catlab.CategoricalAlgebra
using ..MeshUtils
import ...AbstractPlotting: wireframe, wireframe!, mesh, mesh!, scatter, scatter!

export wireframe, wireframe!, mesh, mesh!, scatter, scatter!

# Plotting Wrapper Functions
############################
""" Wrapper function for AbstractPlotting.wireframe
"""
function wireframe(ds::AbstractACSet; kw...)
   wireframe(make_mesh(ds); kw...)
end
""" Wrapper function for AbstractPlotting.wireframe!
"""
function wireframe!(ds::AbstractACSet; kw...)
   wireframe!(make_mesh(ds); kw...)
end

""" Wrapper function for AbstractPlotting.mesh!
"""
function mesh(ds::AbstractACSet; kw...)
   mesh(make_mesh(ds); kw...)
end
""" Wrapper function for AbstractPlotting.mesh!
"""
function mesh!(ds::AbstractACSet; kw...)
   mesh!(make_mesh(ds); kw...)
end

""" Wrapper function for AbstractPlotting.scatter!
"""
function scatter(ds::AbstractACSet; kw...)
  scatter(make_mesh(ds); kw...)
end
""" Wrapper function for AbstractPlotting.scatter!
"""
function scatter!(ds::AbstractACSet; kw...)
   scatter!(make_mesh(ds); kw...)
end

end
