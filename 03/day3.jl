report = (read("input.txt", String) |> (x -> split(x, "\n")))
filter!(x -> x ≠ "", report)
len = length(first(report))

γ, ε = "", ""

for i=1:len
    ones_count = 0
    for line ∈ report
        if line[i] == '1'
            ones_count += 1
        end
    end

    if ones_count ≥ length(report)/2
        global γ = γ * "1"
        global ε = ε * "0"
    else
        global γ = γ * "0"
        global ε = ε * "1"
    end
end

γ = parse(Int64, γ, base=2)
ε = parse(Int64, ε, base=2)

println("The γ rate is $γ")
println("The ε rate is $ε")
println("The power consumption is $(γ * ε)")


###### Part 2
oxygen, CO₂ = copy(report), copy(report)

k = 1
while length(oxygen) > 1
    global k
    count₁ = 0
    for bit_sequence ∈ oxygen
        if bit_sequence[k] == '1'
            count₁ += 1
        end
    end
    majority_bit = count₁ ≥ length(oxygen)/2  ? '1' : '0'
    filter!(x -> x[k] == majority_bit, oxygen)
    k += 1
end


k = 1
while length(CO₂) > 1
    global k
    count₀ = 0
    for bit_sequence ∈ CO₂
        if bit_sequence[k] == '0'
            count₀ += 1
        end
    end
    minority_bit = count₀ ≤ length(CO₂)/2 ? '0' : '1'
    filter!(x -> x[k] == minority_bit, CO₂)
    k += 1
end

println("oxigen = $(parse(Int64, first(oxygen), base=2))")
println("CO₂ = $(parse(Int64, first(CO₂), base=2))")
println("final report = $(parse(Int64, first(oxygen), base=2) * parse(Int64, first(CO₂), base=2))")
