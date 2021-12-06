report = (read("input.txt", String) |> (x -> split(x, "\n")))[1:end-1]
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
