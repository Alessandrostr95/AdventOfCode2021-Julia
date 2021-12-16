# PART 1: trivial approach
f = read("input", String) |> (x -> split(x, ",")) .|> (x -> parse(Int64, x))

function simulate!(sequence::Vector{Int64})
    sequence = sequence .- 1
    newborn = count(x -> x == -1, sequence)
    replace!(sequence, -1 => 6)
    append!(sequence, [8 for _=1:newborn])
end
        
for _=1:80
    global f
    f = simulate!(f)
end

println("after 80 days : $(length(f))")

# PART 2: smart approach
f = read("input", String) |> (x -> split(x, ",")) .|> (x -> parse(Int64, x))

counter_ages = Dict{Int64, Int64}(n => 0 for n=0:8)
for n=0:8
    counter_ages[n] = count(x -> x == n, f)
end

for _=1:256
    global f, counter_ages
    newborn = counter_ages[0]
    for n=0:7
        counter_ages[n] = counter_ages[n+1]
    end
    counter_ages[6] += newborn
    counter_ages[8] = newborn
end
println("after 256 days : $(sum([values(counter_ages)...]))")