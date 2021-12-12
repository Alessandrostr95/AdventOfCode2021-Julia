f = read("input", String) |> (x -> split(x, "\n\n"))

numbers = f |> first |> (x -> split(x, ",")) .|> (x -> parse(Int64, x))

# data structure for the bingo board
mutable struct Board
    table::Matrix{Int64}    # the bingo board
    marked::Set{Int64}      # the numbers marked on the board
    Board(table::T) where T <: AbstractMatrix = new(table, Set{Int64}()) # constructor 
end

# this function marks the number `n` on the board
mark(b::Board, n::Int64) = push!(b.marked, n)

# this function checks if a given Vector is a winning row or column
# returns true if it is a winning row or column
# returns false otherwise
function check(v::Vector{Int64}, b::Board)::Bool
    for x in v
        if x ∉ b.marked
            return false
        end
    end
    return true 
end

# this function checks if given board `b` is a winning board
# returns true if it is a winning board
# returns false otherwise
function wins(b::Board)::Bool
    for i=1:length(b.table[:,1])
        check(b.table[i,:], b) && return true # check row
        check(b.table[:,i], b) && return true # check column
    end
    return false
end

# a Vector of all boards
boards = Board[]
for b in f[2:end]
    push!(boards, begin
        split(b, "\n") .|> split .|> (x -> parse.(Int64, x)) |> (x -> hcat(x...)) |> transpose |> Board
    end)
end

# function that given a winning board `b` calculate and returns its score
# the board `b` must be a winning board!
function calculateScore(b::Board, last::Int64)::Int64
    somma = 0
    for x in b.table
        if x ∉ b.marked
            somma += x
        end
    end
    return somma*last
end

# play the game
for n in numbers
    global boards
    for b in boards
        mark(b, n)
        
        if wins(b)
            println("The first winner score is: $(calculateScore(b, n))")
            return
        end
    end
end

####### PART 2


for b ∈ boards
    b.marked = Set{Int64}()  # reset marked
end

# play the game
i = 1
while length(boards) ≠ 1
    global boards, numbers, i
    n = numbers[i]

    for b in boards
        mark(b, n)
    end

    filter!(x -> !wins(x), boards)
    i += 1
end

last_board = first(boards)
for j=i:length(numbers)
    global numbers, last_board
    n = numbers[i]
    mark(last_board, n)
    if wins(last_board)
        println("The last winner score is: $(calculateScore(last_board, n))")
        return
    end
end