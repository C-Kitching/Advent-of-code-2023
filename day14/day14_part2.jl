
# pacakges
using DataStructures

# roll all rocks in grid to their north most point
function push_north(grid::Vector{Vector{Char}}) :: Vector{Vector{Char}}

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

    return grid
end

# rotate grid clockwise 90 degrees
function rotate_clockwise_90(mat::Vector{Vector{Char}})
    nrows = length(mat)
    ncols = length(mat[1])
    new_mat = [Vector{Char}(undef, nrows) for _ in 1:ncols]

    for i in 1:nrows
        for j in 1:ncols
            new_mat[j][nrows - i + 1] = mat[i][j]
        end
    end

    return new_mat
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
function cycle(grid::Vector{Vector{Char}}) :: Vector{Vector{Char}}

    for _ in 1:4
        grid = push_north(grid)
        grid = rotate_clockwise_90(grid)
    end

    return grid

end

# perform N cycles on the grid
function N_cycles(grid::Vector{Vector{Char}}, N::Int) :: Vector{Vector{Char}}

    # memorisation
    memo = Dict()

    # cycle through
    num_cycles = 0
    while true

        # perform one cycle
        grid = cycle(grid)
        num_cycles += 1
        
        # reach N cycles before repeating
        if num_cycles == N
            return grid

        # check if we've seen this before by comparing contents
        elseif any(memo_grid -> isequal(memo_grid, grid), values(memo))
            break

        # store in memory (deep copy to store the grid's current state)
        else
            memo[num_cycles] = deepcopy(grid)
        end
    end

    if N%length(memo) == 0
        return memo[length(memo)]
    else
        return memo[N%length(memo)]
    end

end


# main function
function day14_part1()

    # read data
    lines = readlines("input/day14_test1.txt")
    grid = Vector{Vector{Char}}()
    for line in lines
        push!(grid, collect(line))
    end

    # cycle grid 1 bilion times
    cycled_grid = N_cycles(grid, 100)

    # compute load on north wall
    load = calculate_load(cycled_grid)

    # print result
    println(load)

end

day14_part1()