expressions = read("input", String) |> split

"""
    Function that removes valid chicks from an expression
"""
function clean(expr::AbstractString)
    x = deepcopy(expr)
    l = -1
    while l ≠ length(x)
        l = length(x)
        x = replace(x, "()" => "")
        x = replace(x, "[]" => "")
        x = replace(x, "{}" => "")
        x = replace(x, "<>" => "")
    end
    x
end

"""
    Function that check if an expression is illegal.
    If true, than return the first illegal char,
    else return nothing
"""
function check(expr::AbstractString)::Union{Char, Nothing}
    open_pars = ['<', '{', '[', '(']
    for x ∈ clean(expr)
        x ∉ open_pars && return x
    end
    return nothing
end

points = Dict{Char, Int64}(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)

illegal_chars = filter(x -> x ≠ nothing, check.(expressions))
counter = Dict{Char, Int64}(
    ')' => count(x -> x == ')', illegal_chars),
    ']' => count(x -> x == ']', illegal_chars),
    '}' => count(x -> x == '}', illegal_chars),
    '>' => count(x -> x == '>', illegal_chars)
)
solution = sum([counter[x]*points[x] for x ∈ ['>', '}', ']', ')']])
println("The total syntax error score is: $solution")

# Part 2

function invert(expr::AbstractString)
    result = reverse(expr)
    result = replace(result, "(" => ")")
    result = replace(result, "[" => "]")
    result = replace(result, "{" => "}")
    result = replace(result, "<" => ">")
    return result
end

closing_expressions = filter(x -> check(x) === nothing, expressions) .|> clean .|> invert

function countScore(closing_expr::AbstractString)::Int64
    points = Dict{Char, Int64}(
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4
    )
    score = 0
    for x ∈ closing_expr
        score = score*5 + points[x]
    end
    return score
end

scores = countScore.(closing_expressions) |> sort
result = scores[convert(Int64, ceil(length(scores) / 2))]
println("The middle score is: $result")