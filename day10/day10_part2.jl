using DataStructures

# reorder coords to form a closed path
function reorder_coords(coords::Vector{Tuple{Int, Int}}) :: Vector{Tuple{Int, Int}}
    path = Vector{Tuple{Int, Int}}()
    for i in 1:2:length(coords)
        push!(path, coords[i])
    end
    for i in length(coords):-2:2
        push!(path, coords[i])
    end

    return path
end

# calculate the number of interior points using Picks theorum
function picks_theorum(area::Float64, boundary_nodes::Int) :: Int
    return Int(area - boundary_nodes/2 + 1)
end

# calculate area with shoelace formula
function shoelace_area(coords::Vector{Tuple{Int, Int}}) :: Float64

    # get size, min of 3
    n = length(coords)
    if n < 3
        throw(ArgumentError("The polygon must have at least 3 verticies"))
    end

    # shoelace formula
    sum1 = sum2 = 0
    for i in 1:n
        y1, x1 = coords[i]
        y2, x2 = coords[mod(i%n, n)+1] # wrap around for last point

        # increment sum
        sum1 += x1*y2
        sum2 += x2*y1
    end
    area = abs(sum1-sum2)/2

    return area
end

# main function
function day10_part2()

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

    # reorder coordinations so they trace a closed path
    path = reorder_coords(visited_nodes)

    # calculate area with shoelace formula
    A = shoelace_area(path)

    # calc num of interior points with Picks theorum
    num_interior_points = picks_theorum(A, length(path))

    # print result
    println(num_interior_points)

end