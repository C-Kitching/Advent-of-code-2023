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

# calculate dig area given the coords of the dig path
function dig_area(path::Vector{Tuple{Int, Int}}) :: Int

    # calculate area with shoelace formula
    A = shoelace_area(path)

    # calc num of interior points with Picks theorum
    num_interior_points = picks_theorum(A, length(path))

    return length(path) + num_interior_points

end


# main function
function day18_part1()

    # read data
    lines = readlines("input/day18.txt")
    moves = Vector{Pair{Char, Int}}()
    for line in lines
        dir = split(line, " ")[1][1]
        num = parse.(Int, split(line, " ")[2])
        push!(moves, dir => num)
    end

    # store dig path
    coords = Vector{Tuple{Int, Int}}()
    push!(coords, (0, 0)) # start at origin

    # map directions to co-ords
    dirs = Dict('R' => (0, 1), 'L' => (0, -1), 'U' => (-1, 0), 'D' => (1, 0)) 

    # perform all moves
    for move in moves

        curr_pos = coords[end] # current position
        dir = dirs[move.first]
        dr, dc = dir[1], dir[2] # row and column changes for that direction
        num_steps = move.second # number of steps to perform

        # move that number of steps in that direction
        for _ in 1:num_steps
            next_pos = (curr_pos[1] + dr, curr_pos[2] + dc)
            push!(coords, next_pos)
            curr_pos = next_pos
        end

    end
    coords = coords[1:end-1] # slice off last point as we go in a loop

    # calculate total dig area
    A = dig_area(coords)

    # print result
    println(A)

end