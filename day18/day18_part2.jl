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
function dig_area(path::Vector{Tuple{Int, Int}}, num_boundary_points::Int) :: Int

    # calculate area with shoelace formula
    A = shoelace_area(path)

    # calc num of interior points with Picks theorum
    num_interior_points = picks_theorum(A, num_boundary_points)

    return num_boundary_points + num_interior_points

end

# main function
function day18_part2()

    # map number to direction
    num_to_dir = Dict(0 => 'R', 1 => 'D', 2 => 'L', 3 => 'U')

    # read data
    lines = readlines("input/day18.txt")
    moves = Vector{Pair{Char, Int}}()
    for line in lines
        num = parse(Int, split(line)[3][3:end-2], base = 16)
        dir = num_to_dir[parse.(Int, split(line)[3][end-1])]
        push!(moves, dir => num)
    end

    # store dig path
    coords = Vector{Tuple{Int, Int}}()
    push!(coords, (0, 0)) # start at origin

    # map directions to co-ords
    dirs = Dict('R' => (0, 1), 'L' => (0, -1), 'U' => (-1, 0), 'D' => (1, 0)) 

    # track boundary points
    num_boundary_points = 0

    # perform all moves
    for move in moves

        curr_pos = coords[end] # current position
        dir = dirs[move.first]
        dr, dc = dir[1], dir[2] # row and column changes for that direction
        num_steps = move.second # number of steps to perform

        # get next point on polygon
        next_pos = (curr_pos[1] + dr*num_steps, curr_pos[2] + dc*num_steps)
        push!(coords, next_pos)

        # add boundary points
        num_boundary_points += num_steps 

    end
    coords = coords[1:end-1] # slice off last point as we go in a loop

    # calculate total dig area
    A = dig_area(coords, num_boundary_points)

    # print result
    println(A)

end