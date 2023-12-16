
# imports
using DataStructures
using StaticLint

# draw energised grid
function draw(grid::Vector{String}, memo::Set{Pair{Char, Tuple{Int, Int}}})

    # split by char so can edit
    new_grid = Vector{Vector{Char}}()
    for row in grid
        push!(new_grid, collect(row))
    end

    # build energised grid
    for r in eachindex(grid)
        for c in eachindex(grid[r])
            if any(x -> x.second == (r,c), memo)
                new_grid[r][c] = '#'
            else
                new_grid[r][c] = '.'
            end
        end
    end

    # recombine
    final = Vector{String}()
    for row in new_grid
        push!(final, join(row))
    end

    println(final)

end

# bounds check
function bounds_check(new_pos::Tuple{Int, Int}, grid::Vector{String}) :: Bool
    if 1 <= new_pos[1] <= length(grid) && 1 <= new_pos[2] <= length(grid[1])
        return true
    else
        return false
    end
end

function single_config(start_dir::Char, start_coord::Tuple{Int, Int}, 
    grid::Vector{String}) :: Int

    # grid dimensions
    R = length(grid)
    C = length(grid[1])

    # push first beam onto queue
    q = Deque{Pair{Char, Tuple{Int, Int}}}()
    push!(q, Pair(start_dir, start_coord))

    # memory
    memo = Set{Pair{Char, Tuple{Int, Int}}}()

    # store visited nodes
    visited = Set{Tuple{Int, Int}}()

    # movement map
    move_map = Dict('^' => (-1, 0), '>' => (0, 1), 'v' => (1, 0), '<' => (0, -1))

    # while beans still in grid
    while !isempty(q)

        # get next beam head
        beam = popfirst!(q)
        dir, loc = beam[1], beam[2]
        r, c = loc[1], loc[2]
        curr = grid[r][c]

        # if seen before then break
        if beam ∈ memo
            continue
        # otherwise store in memory
        else
            push!(memo, beam)
            push!(visited, loc)
        end

        # reflected by mirror
        # move up
        if (curr == '/' && dir == '>') || (curr == '\\' && dir == '<')
            new_pos = (r-1, c)
            if bounds_check(new_pos, grid)
                push!(q, Pair('^', new_pos))
            end
        # move left
        elseif (curr == '/' && dir == 'v') || (curr == '\\' && dir == '^')
            new_pos = (r, c-1)
            if bounds_check(new_pos, grid)
                push!(q, Pair('<', new_pos))
            end
        # move down
        elseif (curr == '/' && dir == '<') || (curr == '\\' && dir == '>')
            new_pos = (r+1, c)
            if bounds_check(new_pos, grid)
                push!(q, Pair('v', new_pos))
            end 
        # move right
        elseif (curr == '/' && dir == '^') || (curr == '\\' && dir == 'v')
            new_pos = (r, c+1)
            if bounds_check(new_pos, grid)
                push!(q, Pair('>', new_pos))
            end 

        # flat side of splitter
        elseif curr == '|' && (dir == '>' || dir == '<')
            if bounds_check((r-1, c), grid)
                push!(q, Pair('^', (r-1, c)))
            end
            if bounds_check((r+1, c), grid)
                push!(q, Pair('v', (r+1, c)))
            end
        elseif curr == '-' && (dir == 'v' || dir == '^')
            if bounds_check((r, c+1), grid)
                push!(q, Pair('>', (r, c+1)))
            end
            if bounds_check((r, c-1), grid)
                push!(q, Pair('<', (r, c-1)))
            end

        # if beam about to exit do nothing
        elseif (curr == '.' && (dir == '^' && r == 1) || (dir == '>' && c == C) || (dir == 'v' && r == R) || (dir == '<' && c == 1))
            continue

        # empty space or pointy beam splitter
        elseif curr == '.' || (curr == '-' && dir ∈ ['>', '<']) || (curr == '|' && dir ∈ ['^', 'v'])
            new_pos = (r+move_map[dir][1], c+move_map[dir][2]) 
            if bounds_check(new_pos, grid)
                push!(q, Pair(dir, new_pos))
            end
        end
        
    end

    # get energized
    energy = length(visited)
    return energy

end

# main function
function day16_part2()

    # read data
    lines = readlines("input/day16.txt")
    grid = Vector{String}()
    for line in lines
        push!(grid, line)
    end

    # for through all combinations
    max_energy = 0
    # top
    for col in eachindex(grid[1])
        max_energy = max(max_energy, single_config('v', (1, col), grid))
    end
    for col in eachindex(grid[end])
        max_energy = max(max_energy, single_config('^', (length(grid), col), grid))
    end
    for row in eachindex(grid)
        max_energy = max(max_energy, single_config('>', (row, 1), grid))
    end
    for row in eachindex(grid)
        max_energy = max(max_energy, single_config('<', (row, length(grid[1])), grid))
    end

    println(max_energy)

end