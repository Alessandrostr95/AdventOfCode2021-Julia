entries = split(read("input", String), "\n") .|> (x -> split(x, " | ")[2]) .|> split
entries = [Base.Iterators.flatten(entries)...]
println(count(x -> length(x) ∈ [2,3,4,7], entries) |> sum)

# Part 2
entries = split(read("input", String), "\n")

function infer(s::T, one::T, four::T)::Int64 where T <: AbstractString
    n = length(s)
    n == 2 && return 1
    n == 3 && return 7
    n == 4 && return 4
    n == 7 && return 8
    if n == 6
        length(setdiff(one, s)) == 1 && return 6
        length(setdiff(four, s)) == 1 && return 0
        return 9
    else
        length(setdiff(one, s)) == 0 && return 3
        length(setdiff(four, s)) == 1 && return 5
        return 2
    end
end

function solve(all_digits::AbstractString, four_digits::AbstractString)::Int64
    s = split(all_digits)
    one = filter(x -> length(x) == 2, s) |> first
    four = filter(x -> length(x) == 4, s) |> first
    four_digits |> split .|> (x -> infer(x, one, four)) |> join |> (x -> parse(Int64, x))
end

println("The result of part 2 is: $([solve(split(x, " | ")...) for x ∈ entries] |> sum)")