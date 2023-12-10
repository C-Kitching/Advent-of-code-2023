using DataStructures

# main function
function day10_part1()

    # read data
    lines = readlines("input/day10_test1.txt")

    # define directions we can move and valid chars at the move location
    dir_map = Dict((0, 1) => ['-', '7', 'J'], (1,0) => ['|', '7', 'F'], (0,-1) => ['-', 'L', 'F'], (-1,0) => ['|', 'J', 'L'])

    # read into grid of chars
    grid = Vector{Vector{Char}}()
    for line in lines
        temp = push!(grid, collect(line))
    end
    rows = length(grid)
    cols = length(grid[1]) 

    # find start point
    visited_nodes = Tuple{Int, Int}[]
    queue = Deque{Tuple}()
    for (i, row) in enumerate(grid)
        for (j, char) in enumerate(row)
            if char == 'S'
                start = (i, j)
                push!(visited_nodes, start)
                push!(queue, start)
            end
        end
    end

    # bfs
    while !isempty(queue)
        curr = pop!(queue)

        # search all directions around
        for (dir, chars) in pairs(dir_map)

            # potential new location
            new_pos = (curr[1]+dir[1], curr[2]+dir[2])

            # check bounds and that we haven't seen it
            if 1 <= new_pos[1] <= rows && 1 <= new_pos[2] <= cols && new_pos ∉ visited_nodes

                # check that char at that pos is valid
                if grid[new_pos[1]][new_pos[2]] ∈ chars

                    # add new pos to queue and visited nodes
                    push!(queue, new_pos)
                    push!(visited_nodes, new_pos)
                end
            end
        end
    end

    println(length(visited_nodes))


end

day10_part1()