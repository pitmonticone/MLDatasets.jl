export Cora

"""
    Cora

The full Cora citation network dataset from the
`"Deep Gaussian Embedding of Graphs: Unsupervised Inductive Learning via
Ranking" <https://arxiv.org/abs/1707.03815>`_ paper.
Nodes represent documents and edges represent citation links.

## Interface

- [`Cora.alldata`](@ref)
"""
module Cora

using DataDeps
using ..MLDatasets: datafile
using DelimitedFiles: readdlm

const DEPNAME = "Cora"
const LINK = "http://nrvis.com/download/data/labeled/cora.zip"
const DOCS = "http://networkrepository.com/cora.php"


function __init__()
    register(DataDep(
        DEPNAME,
        """
        Dataset: The $DEPNAME dataset.
        Website: $DOCS
        """,
        LINK,
        "a3e3a37c34c9385fe8089bbc7c17ef78ecc3bdf8a4b03b80d02aaa080d9501c8",  # if checksum omitted, will be generated by DataDeps
        post_fetch_method = unpack
    ))
end

"""
    alldata(; dir=nothing)

Retrieve the Cora dataset. The output is a named tuple with fields

- `edges`
- `node_labels`
- `directed`

## Usage Examples
```juliarepl
julia> using MLDatasets: Cora

julia> data = Cora.alldata()
(edges = [1 9; 1 436; … ; 2708 1390; 2708 2345], node_labels = [3, 6, 5, 5, 4, 4, 7, 3, 3, 7  …  4, 4, 4, 3, 2, 2, 2, 2, 1, 3], directed = true)
```
"""
function alldata(; dir=nothing)
    edges = readdlm(datafile(DEPNAME, "cora.edges", dir), ',', Int)
    @assert all(edges[:,3] .== 1)
    edges = edges[:,1:2]
    
    node_labels = readdlm(datafile(DEPNAME, "cora.node_labels", dir), ',', Int)
    node_labels = node_labels[:,2] # first column is just 1:n
    
    return (; edges=edges, 
              node_labels=node_labels, 
              directed=true)
end

end