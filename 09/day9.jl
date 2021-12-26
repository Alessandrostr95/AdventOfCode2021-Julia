heightmap = read("input", String) |> (x -> join(x, " ")) |> (x -> split(x, " \n ")) .|> split .|> (x -> parse.(Int64, x)) |> (x -> hcat(x...)) |> transpose |> Matrix

function find_local_minimum_coords(M::Matrix)::Vector{Tuple{Int64, Int64}}
    local_minimum_coords = Tuple{Int64, Int64}[]

    rows, columns = length(M[:,1]), length(M[1,:])

    # corners
    # top-left
    (M[1, 1] < M[1, 2] && M[1, 1] < M[2, 1]) && push!(local_minimum_coords, (1, 1))
    # top-right
    (M[1, end] < M[1, end-1] && M[1, end] < M[2, end]) && push!(local_minimum_coords, (1, columns))
    # bottom-right
    (M[end, end] < M[end, end-1] && M[end, end] < M[end-1, end]) && push!(local_minimum_coords, (rows, columns))
    # bottom-left
    (M[end, 1] < M[end, 2] && M[end, 1] < M[end-1, 1]) && push!(local_minimum_coords, (rows, 1))
    
    # top edge
    for j=2:columns-1
        (
            M[1, j] < M[1, j-1] &&
            M[1, j] < M[2, j] &&
            M[1, j] < M[1, j+1]
        ) && push!(local_minimum_coords, (1, j))
    end

    # right edge
    for i=2:rows-1
        (
            M[i, end] < M[i-1, end] &&
            M[i, end] < M[i, end-1] &&
            M[i, end] < M[i+1, end]
        ) && push!(local_minimum_coords, (i, columns))
    end

    # bottom edge
    for j=2:columns-1
        (
            M[end, j] < M[end, j-1] &&
            M[end, j] < M[end-1, j] &&
            M[end, j] < M[end, j+1]
        ) && push!(local_minimum_coords, (rows, j))
    end

    # left edge
    for i=2:rows-1
        (
            M[i, 1] < M[i-1, 1] &&
            M[i, 1] < M[i, 2] &&
            M[i, 1] < M[i+1, 1]
        ) && push!(local_minimum_coords, (i, 1))
    end

    # any others
    for i=2:rows-1, j=2:columns-1
        (
            M[i, j] < M[i, j + 1] &&
            M[i, j] < M[i, j - 1] &&
            M[i, j] < M[i + 1, j] &&
            M[i, j] < M[i - 1, j]
        ) && push!(local_minimum_coords, (i, j))
    end

    return local_minimum_coords
end

low_points = find_local_minimum_coords(heightmap)
solution = [heightmap[i,j]+1 for (i,j) in low_points] |> sum
println("The solution of part 1 is: $solution")

# Part 2

mutable struct Basian
    low_point::Tuple{Int64, Int64}
    points::Set{Tuple{Int64, Int64}}
    function Basian(low_point::Tuple{Int64, Int64})
        return new(low_point, Set([low_point]))
    end
end
add!(b::Basian, p::Tuple{Int64, Int64}) = push!(b.points, p)

function get_neighboors(point::Tuple{Int64, Int64}, M::Matrix)::Vector{Tuple{Int64, Int64}}
    rows, columns = length(M[:,1]), length(M[1,:])
    i, j = point

    # case corners
    # top-left
    (i == j == 1) && return [(1, 2), (2, 1)]
    # top-right
    (i == 1 && j == columns) && return [(1, j-1), (2, j)]
    # bottom-right
    (i == rows && j == columns) && return [(i, j-1), (i-1, j)]
    # bottome-left
    (i == rows && j == 1) && return [(i-1, j), (i, j+1)]

    # case edges
    # top
    i == 1 && return [(1, j-1), (2, j), (1, j+1)]
    # right
    j == columns && return [(i-1, j), (i, j-1), (i+1, j)]
    # bottom
    i == rows && return [(i, j-1), (i-1, j), (i, j+1)]
    # left
    j == 1 && return [(i-1, 1), (i, 2), (i+1, 1)]

    # otherwise
    return [(i+1, j), (i-1, j), (i, j+1), (i, j-1)]
end

function expand_basian(low_point::Tuple{Int64, Int64}, M::Matrix)::Basian
    basian = Basian(low_point)
    queue = [low_point]
    while !isempty(queue)
        x = pop!(queue)
        if M[x[1], x[2]] ≠ 9
            add!(basian, x)
            neighs = get_neighboors(x, M)
            for y ∈ neighs
                if !(y ∈ basian.points)
                    pushfirst!(queue, y)
                end
            end
        end
    end
    return basian
end

basians_sizes = [expand_basian(x, heightmap) for x in low_points] .|> (x -> length(x.points))
solution = sort!(basians_sizes, rev=true)[1:3] |> prod
println("The solution of part 2 is: $solution")

# using Plots: pyplot, heatmap, gui
# pyplot()
# heatmap(heightmap) |> gui