""" Versione banale per elaborare il file
report = Int64[]
open("input.txt", "r") do f
    while !eof(f)
        push!(report, parse(Int64, readline(f)))
    end
end
"""

# Versione 1-line
report = read("input.txt", String) |> (x -> replace(x, "\n" => " ")) |> split .|> (x -> parse(Int64, x))


####### PART 1
result = 0
for i=2:length(report)
    if report[i] > report[i-1]
       global result += 1
    end
end

println("There are $result measurements larger than the previous.")

####### PART 2
result = 0
for i=2:length(report)-2
    if sum(report[i:i+2]) > sum(report[i-1:i+1])
        global result += 1
    end
end

println("There are $result sums of 3-measurements windows larger than the previous.")
