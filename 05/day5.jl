using SparseArrays

f = read("input", String) |> (x -> split(x, "\n"))
lines = Pair{Tuple{Int64, Int64}, Tuple{Int64, Int64}}[]

xs = Set{Int64}()
ys = Set{Int64}()
for l ∈ f
    global lines, xs, ys
    coord = replace(l, "->" => " ") |> (x -> replace(x, "," => " ")) |> split .|> (x -> parse(Int64, x))
    if coord[1] == coord[3] || coord[2] == coord[4]
        push!(lines, (coord[1], coord[2]) => (coord[3], coord[4]))
        push!(xs, coord[1], coord[3])
        push!(ys, coord[2], coord[4])
    end
end

A = spzeros(maximum(xs), maximum(ys))
for l ∈ lines
    p1, p2 = l
    if p1[1] == p2[1]
        from, to = p1[2] < p2[2] ? (p1[2], p2[2]) : (p2[2], p1[2])
        for i=from:to
            A[p1[1], i] += 1
        end
    else
        from, to = p1[1] < p2[1] ? (p1[1], p2[1]) : (p2[1], p1[1])
        for i=from:to
            A[i, p1[2]] += 1
        end
    end
end

println(A)
n = count(x -> x ≥ 2, A)
println("There are $n points where at least two lines overlap.")

# --- Part Two ---
diagonal_lines = Pair{Tuple{Int64, Int64}, Tuple{Int64, Int64}}[]

function is_diagonal(l::Vector{Int64})::Bool
    p1, p2 = l[1:2], l[3:4]
    return abs(p1[1] - p2[1]) == abs(p1[2] - p2[2])
end

for l ∈ f
    global diagonal_lines, xs, ys
    coord = replace(l, "->" => " ") |> (x -> replace(x, "," => " ")) |> split .|> (x -> parse(Int64, x))
    if is_diagonal(coord)
        push!(diagonal_lines, (coord[1], coord[2]) => (coord[3], coord[4]))
    end
end

for l ∈ diagonal_lines
    p1, p2 = l
    Δ = abs(p1[1] - p2[1])

    if p1[1] < p2[1] && p1[2] < p2[2]
        for i=0:Δ
            A[p1[1] + i, p1[2] + i] += 1
        end

    elseif p1[1] > p2[1] && p1[2] > p2[2]
        for i=0:Δ
            A[p1[1] - i, p1[2] - i] += 1
        end

    elseif p1[1] < p2[1] && p1[2] > p2[2]
        for i=0:Δ
            A[p1[1] + i, p1[2] - i] += 1
        end

    elseif p1[1] > p2[1] && p1[2] < p2[2]
        for i=0:Δ
            A[p1[1] - i, p1[2] + i] += 1
        end
    end
end

println(A)
n = count(x -> x ≥ 2, A)
println("There are $n points where at least two lines overlap.")