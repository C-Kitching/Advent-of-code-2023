# packages
using DataStructures

# exapnd universe by addings rows and cols of .
function expand_universe(empty_rows::Vector{Int}, empty_cols::Vector{Int}, 
    universe::Vector{Vector{Char}}) :: Vector{Vector{Char}}
    
    # add rows
    for row in empty_rows
        insert!(universe, row, fill('.', length(universe[1])))
    end

    # add cols
    for col in empty_cols
        for row in universe
            insert!(row, col+1, '.')
        end
    end

    return universe
end


# find rows with no galaxies
function find_empty_cols(universe::Vector{Vector{Char}}) :: Vector{Int}

    # find rows and cols with no galaxies
    rows = length(universe)
    cols = length(universe[1])

    empty_cols = Vector{Int}()

    # Check for empty columns
    for j in cols:-1:1
        if all(universe[i][j] != '#' for i in 1:rows)
            push!(empty_cols, j)
        end
    end

    return empty_cols
end

# find rows with no galaxies
function find_empty_rows(universe::Vector{Vector{Char}}) :: Vector{Int}

    # find rows and cols with no galaxies
    rows = length(universe)
    cols = length(universe[1])

    empty_rows = Vector{Int}()

    # Check for empty rows
    for i in rows:-1:1
        if all(universe[i][j] != '#' for j in 1:cols)
            push!(empty_rows, i)
        end
    end

    return empty_rows
end

# bfs to find min distance between two galaxies
function bfs(start::Tuple{Int, Int}, goal::Tuple{Int, Int}, 
    universe::Vector{Vector{Char}}) :: Int

    # define directions
    dirs = [(1,0), (-1,0), (0,1), (0,-1)]

    # define bfs memory and queue
    visited = Set{Tuple{Int, Int}}()
    queue = Deque{Tuple{Tuple{Int, Int}, Int}}()
    push!(visited, start)
    push!(queue, (start, 0))

    # perform bfs
    while !isempty(queue)
        (curr, dist ) = popfirst!(queue)

        # found goal
        if curr == goal
            return dist
        end

        for dir in dirs


            
        end


    end


end

# find minimum distances between all pairs in the universe
function find_min_dist_pairs(universe::Vector{Vector{Char}})

    rows = length(universe)
    cols = length(universe[1])

    # find galaxies
    galaxy_posisitons = [(i, j) for i in 1:rows for j in 1:cols if universe[i][j] == '#']

    # calc min distance for all pairs of galaxies
    distances = Dict()
    for i in 1::length(galaxy_positions)
        for j in (i+1)::length(galaxy_positions)
            distance = bfs(galaxy_posisitons[i], galaxy_posisitons[j], universe)
            distances[(galaxy_posisitons[i], galaxy_posisitons[j])] = distance
        end
    end

end

# main function
function day11_part1()

    # read data
    lines = readlines("input/day11_test1.txt")

    # put into universe
    universe = Vector{Vector{Char}}()
    for line in lines
        push!(universe, collect(line))
    end

    # find rows and cols with no galaxies
    empty_rows = find_empty_rows(universe)
    empty_cols = find_empty_cols(universe)

    # exapnd universe
    expanded_universe = expand_universe(empty_rows, empty_cols, universe)

    # find min distances between all pairs
    min_dists = find_min_dist_pairs(expanded_universe)


end

day11_part1()