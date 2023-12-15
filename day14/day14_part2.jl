
# pacakges
using DataStructures

# roll all rocks in grid to their north most point
function push_north!(grid::Vector{Vector{Char}})

    # go through all columns
    for col in eachindex(grid[1])

        # declare last empty position
        empty_pos_queue = Deque{Pair{Int, Int}}()

        # go through each row
        for row in eachindex(grid)

            # found valid empty position and currently without empty pos
            if grid[row][col] == '.'
                push!(empty_pos_queue, row => col)

            # round rock and valid last empty pos
            elseif grid[row][col] == 'O' && !isempty(empty_pos_queue)

                # swap boulder and last empty pos
                last_empty_pos = popfirst!(empty_pos_queue)
                grid[row][col], grid[last_empty_pos[1]][last_empty_pos[2]] = grid[last_empty_pos[1]][last_empty_pos[2]], grid[row][col]

                # current pos now empty
                push!(empty_pos_queue, row => col)

            # cube rock so delete all valid positions so far
            elseif grid[row][col] == '#' && !isempty(empty_pos_queue)
                empty!(empty_pos_queue)
            end

        end
    end
end

# rotate grid 90 degrees clockwise
function rotate_matrix!(matrix::Vector{Vector{Char}})
    n = length(matrix)
    for layer in 1:div(n, 2)
        first = layer
        last = n - layer + 1
        for i in first:last-1
            offset = i - first
            top = matrix[first][i]  # save top

            # left -> top
            matrix[first][i] = matrix[last-offset][first]

            # bottom -> left
            matrix[last-offset][first] = matrix[last][last-offset]

            # right -> bottom
            matrix[last][last-offset] = matrix[i][last]

            # top -> right
            matrix[i][last] = top
        end
    end
end

# calculate load on north wall
function calculate_load(grid::Vector{Vector{Char}}) :: Int

    load = 0
    N = length(grid)

    # go through each line
    for (i, row) in enumerate(grid)
        load += (N - (i-1))*count(c -> c == 'O', row)
    end

    return load

end

# perform a cycle, i.e N -> W -> S -> E
function cycle!(grid::Vector{Vector{Char}}) :: Vector{Vector{Char}}

    for _ in 1:4
        push_north!(grid)
        rotate_matrix!(grid)
    end

    return grid

end

# perform N cycles on the grid
function N_cycles(grid::Vector{Vector{Char}}, N::Int) :: Vector{Vector{Char}}

    # memorisation
    memo = Dict{String, Int}()
    memo[join(join.(grid))] = 0

    # find cycle length
    cycle_start = cycle_end = 0
    for i in 1:N

        # perform one cycle
        grid = cycle!(grid)
        s = join(join.(grid))

        # found start of cycle
        if haskey(memo, s)
            cycle_start = memo[s]
            cycle_end = i
            break
        end

        # store in memory
        memo[s] = i
    end
    empty!(memo)

    # perform remaining steps in cycle
    steps_left = mod(N-cycle_end, cycle_end-cycle_start)
    for _ ∈ 1:steps_left
        grid = cycle!(grid)
    end

    return grid

end


# main function
function day14_part2()

    # read data
    lines = readlines("input/day14.txt")
    grid = Vector{Vector{Char}}()
    for line in lines
        push!(grid, collect(line))
    end

    # cycle grid 1 bilion times
    cycled_grid = N_cycles(grid, 1000000000)

    # compute load on north wall
    load = calculate_load(cycled_grid)

    # print result
    println(load)

end