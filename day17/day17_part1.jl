

# define state of each cell
struct Cell
    cost::Int # cost to reach cell 
    prev::Tuple{Int, Int} # coords of previous cell
    steps::Int # number of steps taken in current direction
    dir::Symbol # direction of last move
end

# main function
function day17_part1()

    # read data
    lines = readlines("input/day17_test.txt")
    grid = Vector{String}()
    for line in lines
        push!(grid, line)
    end
    rows = length(grid)
    cols = length(grid[0])






end

day17_part1()