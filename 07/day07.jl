pos = [parse(Int64, x) for x in split(read("input", String), ",")]
[sum(abs.(pos .- n)) for n=1:maximum(pos)] |> minimum |> println
[sum(abs.(pos .- n) .|> (x -> x*(x+1)/2)) for n=1:maximum(pos)] |> minimum |> println