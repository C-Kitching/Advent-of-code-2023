
# packages
using DataStructures

function fill(sr::Int, sc::Int, steps::Int, 
    grid::Vector{Vector{Char}}) :: Int

    ans = Set{Tuple{Int, Int}}() # set of visitable nodes
    seen = Set{Tuple{Int, Int}}() # mark seen nodes

    # initialise queue with (row, col, steps left)
    q = Deque{Tuple{Int, Int, Int}}()
    push!(q, (sr, sc, 64))

    # bfs
    while !isempty(q)

        # get next items
        row, col, steps = popfirst!(q)

        # if we have an even number of steps left then this node is visitable
        if steps%2 == 0
            push!(ans, (row, col))
        end

        # no more steps left
        if steps == 0
            continue
        end

        # check all neighbours
        for (nr, nc) ∈ [(row+1, col), (row-1, col), (row, col+1), (row, col-1)]

            # skip out of bounds, rocks or seen nodes
            if 1 ≤ nr ≤ R && 1 ≤ nc ≤ C && grid[nr][nc] ≠ '#' && (nr, nc) ∉ seen
                push!(seen, (nr, nc))
                push!(q, (nr, nc, steps-1))
            end
        end
    end

    return length(ans)

end

# main function
function day21_part2()

    # read data
    lines = readlines("input/day21.txt")
    grid = Vector{Vector{Char}}()
    for line in lines
        push!(grid, collect(line))
    end
    R = length(grid)
    C = length(grid[1])

    # find start pos
    sr = sc = 0
    for (r, row) in enumerate(grid)
        for (c, char) in enumerate(row)
            if char == 'S'
                sr = r
                sc = c
                break
            end
        end
    end


end

day21_part2()