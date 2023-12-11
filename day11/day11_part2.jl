# packages
using DataStructures

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

# count the number of empty cols and rows between two points
function count_empty_cols_and_rows(p1::Tuple{Int, Int}, p2::Tuple{Int, Int},
    empty_rows::Vector{Int}, empty_cols::Vector{Int}) :: Int

    # get boundaries
    min_row = min(p1[1], p2[1])
    max_row = max(p1[1], p2[1])
    min_col = min(p1[2], p2[2])
    max_col = max(p1[2], p2[2])

    # count empty rows and cols between points
    res = 0
    for empty_row in empty_rows
        if min_row < empty_row < max_row
            res += 1
        end
    end
    for empty_col in empty_cols
        if min_col < empty_col < max_col
            res += 1
        end
    end

    return res
end

# find minimum distances between all pairs in the universe
function find_min_dist_sum(universe::Vector{Vector{Char}},
    empty_rows::Vector{Int}, empty_cols::Vector{Int}) :: Int

    rows = length(universe)
    cols = length(universe[1])

    # find galaxies
    galaxy_positions = [(i, j) for i in 1:rows for j in 1:cols if universe[i][j] == '#']
    N = length(galaxy_positions)

    # calc min distance sum between all pairs
    min_dist_sum = 0
    for i in 1:N
        galaxy1 = galaxy_positions[i]
        for j in (i+1):N
            galaxy2 = galaxy_positions[j]

            # distance with no expansion
            raw_distance = abs(galaxy1[1] - galaxy2[1]) + abs(galaxy1[2] - galaxy2[2])

            # determine how many empty cols and rows between the galaxies
            empty = count_empty_cols_and_rows(galaxy1, galaxy2, empty_rows, empty_cols)

            # cal distance with expansion
            min_dist_sum += (raw_distance - empty) + empty*1e6

        end
    end
    
    return min_dist_sum
end

# main function
function day11_part2()

    # read data
    lines = readlines("input/day11.txt")

    # put into universe
    universe = Vector{Vector{Char}}()
    for line in lines
        push!(universe, collect(line))
    end

    # find rows and cols with no galaxies
    empty_rows = find_empty_rows(universe)
    empty_cols = find_empty_cols(universe)

    # find min distances between all pairs
    min_dist_sum = find_min_dist_sum(universe, empty_rows, empty_cols)

    # print result
    println(min_dist_sum)

end