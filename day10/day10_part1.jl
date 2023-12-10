using DataStructures

# main function
function day10_part1()

    # read data
    lines = readlines("input/day10.txt")

    # define directions we can move and valid chars at the move location
    # right, down, left, up
    curr_map = Dict((0, 1) => ['S','-', 'L', 'F'], (1,0) => ['S','|', 'F', '7'], (0,-1) => ['S','-', '7', 'J'], (-1,0) => ['S','|', 'J', 'L'])
    next_map = Dict((0, 1) => ['-', '7', 'J'], (1,0) => ['|', 'L', 'J'], (0,-1) => ['-', 'L', 'F'], (-1,0) => ['|', 'F', '7'])

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
        curr = popfirst!(queue)

        # search all directions around
        for (dir, chars) in pairs(next_map)

            # potential new location
            new_pos = (curr[1]+dir[1], curr[2]+dir[2])

            # check bounds and that we haven't seen it
            if 1 <= new_pos[1] <= rows && 1 <= new_pos[2] <= cols && new_pos ∉ visited_nodes

                # check current and next pipe piece connect in valid way
                if grid[new_pos[1]][new_pos[2]] ∈ chars && grid[curr[1]][curr[2]] ∈ curr_map[dir]

                    # add new pos to queue and visited nodes
                    push!(queue, new_pos)
                    push!(visited_nodes, new_pos)
                end
            end
        end
    end

    # print result
    println(Int(length(visited_nodes)/2))

end