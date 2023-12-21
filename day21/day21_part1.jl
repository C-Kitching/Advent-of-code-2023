

# main function
function day21_part1()

    moves = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    # read data
    lines = readlines("input/day21_test.txt")
    grid = Vector{Vector{Char}}()
    for line in lines
        push!(grid, collect(line))
    end
    R = length(grid)
    C = length(grid[1])

    # build adj matrix
    A = [[0 for _ in 1:R*C] for _ in 1:R*C]
    for i in 1:R
        for j in (i+1):C

            node_num = (i-1)*C + (j-1)

            for move in moves
                new_pos = (i+move[1], j+move[2])

                # boudns check
                if 1 ≤ new_pos[1] ≤ R && 1 ≤ new_pos[2] ≤ C

                    # if we could move there
                    if grid[new_pos[1]][new_pos[2]] ≠ '#'

                        neighbour_num = (new_pos[1] - 1)*C + new_pos[2]

                        A[node_num][neighbour_num] = 1
                        A[neighbour_num][node_num] = 1
                    end
                end
            end
        end
    end

    # convert to matrix
    







end

day21_part1()