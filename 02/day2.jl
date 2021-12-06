FORWARD, UP, DOWN = "forward", "up", "down"

commands = (read("input.txt", String) |> (x -> split(x, "\n")))[1:end-1] .|> split

depth_pos, horizontal_pos = 0, 0

for command ∈ commands
    if command[1] == FORWARD
        global horizontal_pos += parse(Int64, command[2])
    elseif command[1] == DOWN
        global depth_pos += parse(Int64, command[2])
    elseif command[1] == UP
        global depth_pos -= parse(Int64, command[2])
    end
end

println("The current coordinates are:")
println("Depth     :\t$depth_pos")
println("Horizontal:\t$horizontal_pos")
println("The product is $(depth_pos * horizontal_pos)")

#### PART 2
depth_pos, horizontal_pos, aim = 0, 0, 0

for command ∈ commands
    if command[1] == FORWARD
        global horizontal_pos += parse(Int64, command[2])
        global depth_pos += parse(Int64, command[2]) * aim
    elseif command[1] == DOWN
        global aim += parse(Int64, command[2])
    elseif command[1] == UP
        global aim -= parse(Int64, command[2])
    end
end

println("The current coordinates are:")
println("Depth     :\t$depth_pos")
println("Horizontal:\t$horizontal_pos")
println("The final aim is $aim")
println("The product is $(depth_pos * horizontal_pos)")
