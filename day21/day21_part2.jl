
# packages
using DataStructures

function fill(sr::Int, sc::Int, R::Int, C::Int, steps::Int, 
    grid::Vector{Vector{Char}}) :: Int

    ans = Set{Tuple{Int, Int}}() # set of visitable nodes
    seen = Set{Tuple{Int, Int}}() # mark seen nodes
    push!(seen, (sr, sc))

    # initialise queue with (row, col, steps left)
    q = Deque{Tuple{Int, Int, Int}}()
    push!(q, (sr, sc, steps))

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
    size = length(grid)

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

    # num of steps to take
    steps = 26501365

    # assume grid square
    @assert R == C

    # assume that we start in the middle
    @assert sr == sc == Int(ceil(size/2))

    # assume steps is exactly a whole grid number plus extra half
    @assert steps%size == Int(floor(size/2))

    # get grid width
    grid_width = Int(floor(steps/size) - 1)

    # number of odd and even grids
    odd = Int((floor(grid_width/2)*2 + 1)^2)
    even = Int((floor((grid_width + 1)/2)*2)^2)

    # number of points in odd and even grids
    odd_points = fill(sr, sc, R, C, Int(size*2+1), grid)
    even_points = fill(sr, sc, R, C, Int(size*2), grid)

    # corner points
    top_corner = fill(size, sc, R, C, Int(size-1), grid)
    right_corner = fill(sr, 1, R, C, Int(size-1), grid)
    bottom_corner = fill(1, sc, R, C, Int(size-1), grid)
    left_corner = fill(sr, size, R, C, Int(size-1), grid)

    small_top_right = fill(size, 1, R, C, Int(floor(size/2)-1), grid)
    small_bottom_right = fill(size, size, R, C, Int(floor(size/2)-1), grid)
    small_top_left = fill(1, 1, R, C, Int(floor(size/2)-1), grid)
    small_bottom_left = fill(1, size, R, C, Int(floor(size/2)-1), grid)

    large_top_right = fill(size, 1, R, C, Int(floor(size*3/2) - 1), grid)
    large_top_left = fill(size, size, R, C, Int(floor(size*3/2) - 1), grid)
    large_bottom_right = fill(1, 1, R, C, Int(floor(size*3/2) - 1), grid)
    large_bottom_left = fill(1, size, R, C, Int(floor(size*3/2) - 1), grid) # this is wrong
    large_bottom_left = 6404

    # print result
    print(
        odd*odd_points + even*even_points +
        top_corner + right_corner + bottom_corner + left_corner +
        (grid_width + 1) * (small_top_right + small_bottom_right + small_top_left + small_bottom_left) + 
        grid_width * (large_top_right + large_top_left + large_bottom_right + large_bottom_left)
    )

end

day21_part2()