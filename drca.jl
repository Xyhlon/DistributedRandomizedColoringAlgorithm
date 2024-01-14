using Pkg
Pkg.add(["Colors", "Plots", "GraphPlot", "DataStructures", "Compose", "Graphs", "Cairo"])
using GraphPlot
using Plots
using Compose
using Graphs
using Cairo
using DataStructures

mutable struct vertexData
  c::Int64
  nColors::Vector{Int64}
end

function localColorSelection(id, lD, colors)
  localData = lD[id]
  if localData.c == 0
    colorCandidate = rand(setdiff(colors, localData.nColors))
    localData.c = colorCandidate
  end
end

function localCandidateBroadcast(id, lD, graph)
  for neigh in neighbors(graph, id)
    push!(lD[neigh].nColors, lD[id].c)
  end
end

function localCleanUp(id, lD, graph, uncolored)
  if lD[id].c ∈ lD[id].nColors
    for neigh in neighbors(graph, id)
      deleteat!(lD[neigh].nColors, findfirst(isequal(lD[id].c), lD[neigh].nColors))
    end
    lD[id].c = 0
    return
  end
  setdiff!(uncolored, id)
end

function simulate(g, Δ)
  colors = Set(1:Δ+1)
  println(colors)
  uncolored::Set{Int64} = Set(collect(vertices(g)))
  localData = Vector{vertexData}(undef, nv(g))
  for i in 1:nv(g)
    localData[i] = vertexData(0, Vector{Int64}())
  end

  while !isempty(uncolored)
    for id in uncolored
      localColorSelection(id, localData, colors)
    end
    for id in uncolored
      localCandidateBroadcast(id, localData, g)
    end
    tmpuncolored = deepcopy(uncolored)
    for id in tmpuncolored
      localCleanUp(id, localData, g, uncolored)
    end
  end

  return map(x -> x.c, localData)
end

function test_coloring(g, coloring, Δ)
  for v in vertices(g)
    for neigh in neighbors(g, v)
      if (coloring[v] == coloring[neigh]) || (coloring[v] > Δ + 1) || (coloring[neigh] > Δ + 1)
        @assert false, "Shit"
      end
    end
  end
end

function generate_random_unweighted_graph(num_vertices, num_edges, Δ)
  g = SimpleGraph(num_vertices)
  candidateVertices = Set(1:num_vertices)
  while ne(g) < num_edges
    if length(candidateVertices) == 1
      break
    end
    u, v = rand(candidateVertices, 2)
    if length(neighbors(g, u)) == Δ
      setdiff!(candidateVertices, u)
      continue
    elseif length(neighbors(g, v)) == Δ
      setdiff!(candidateVertices, v)
      continue
    end

    if length(candidateVertices) == 2 && u != v && has_edge(g, u, v)
      break
    end
    if u != v && !has_edge(g, u, v)
      add_edge!(g, u, v)
    end
  end
  return g
end

function visualize_graph(g, name, colormap)
  realColors = distinguishable_colors(length(colormap), colorant"blue")
  # realColors = theme_palette(:auto).colors.colors
  vertex_colors = [realColors[colormap[v]] for v in vertices(g)]
  nodelabels = 1:nv(g)
  draw(PDF(name, 16cm, 16cm), gplot(g, NODELABELSIZE=10 / sqrt(nv(g)), nodelabel=nodelabels, nodefillc=vertex_colors))
end

max_num_vertices, max_Δ = 800, 8
several = 100

for i in 1:several
  num_vertices = rand(max_Δ:max_num_vertices)
  Δ = rand(2:2:max_Δ)
  num_edges = rand(num_vertices:num_vertices*Δ/2)

  println("Generating Graph")
  graph = random_regular_graph(num_vertices, Δ)
  if is_directed(graph)
    @assert false "Created directed Graph!!!"
  end
  println("Starting simulation")
  coloring = simulate(graph, Δ)
  println(coloring)
  test_coloring(graph, coloring, Δ)
  if i == several
    visualize_graph(graph, "graph.pdf", coloring)
  end
end

for i in 1:several
  num_vertices = rand(max_Δ:max_num_vertices)
  Δ = rand(2:max_Δ)
  num_edges = rand(num_vertices:num_vertices*Δ/2)

  println("Generating Graph")
  graph = generate_random_unweighted_graph(num_vertices, num_edges, Δ)
  if is_directed(graph)
    @assert false "Created directed Graph!!!"
  end
  println("Starting simulation")
  coloring = simulate(graph, Δ)
  println(coloring)
  test_coloring(graph, coloring, Δ)
  if i == several
    visualize_graph(graph, "graph.pdf", coloring)
  end
end

