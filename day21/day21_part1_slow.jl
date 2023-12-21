
# packages
using LinearAlgebra

function read_data()

    moves = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    # read data
    lines = readlines("input/day21_test.txt")
    grid = Vector{Vector{Char}}()
    for line in lines
        push!(grid, collect(line))
    end
    R = length(grid)
    C = length(grid[1])

    # need to find start
    start = 0

    # Use a 2D array for A
    A = zeros(BigInt, R*C, R*C)

    for i in 1:R
        for j in 1:C
            node_num = (i-1)*C + j

            # Check for 'S'
            if grid[i][j] == 'S'
                start = node_num
            end

            for move in moves
                new_i, new_j = i + move[1], j + move[2]

                # Bounds check
                if 1 ≤ new_i ≤ R && 1 ≤ new_j ≤ C && grid[new_i][new_j] ≠ '#'
                    neighbour_num = (new_i - 1)*C + new_j
                    A[node_num, neighbour_num] = 1
                end
            end
        end
    end

    return A, start

end

# main function
function day21_part1()

    # read data
    A, start = read_data()    

    # raise to power
    A_powered = A^2

    # Calculate the number of destinations
    dests = count(x -> x != 0, A_powered[start, :])

    # Print result
    println(dests)

end