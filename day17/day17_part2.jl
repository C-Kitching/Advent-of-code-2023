
# includes
using DataStructures

struct node
    r::Int # row
    c::Int # column
    dr::Int # row direction
    dc::Int # column direction
    steps::Int # consecutive steps taken
end

# main function
function day17_part2()

    # read data
    lines = readlines("input/day17.txt")
    grid = Vector{Vector{Int}}()
    for line in lines
        push!(grid, parse.(Int, collect(line)))
    end
    rows = length(grid)
    cols = length(grid[1])

    # priority queue where keys are heatloss and values are nodes
    pq = PriorityQueue{node, Int}()
    enqueue!(pq, node(1, 1, 0, 0, 0), 0)

    # track visisted nodes
    visited = Set{Tuple{Int, Int, Int, Int, Int}}()

    # possible directions for turning
    dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    
    # Djikstras
    while !isempty(pq)

        # get next node
        item = peek(pq)
        curr, heatloss = item.first, item.second
        r, c, dr, dc, steps = curr.r, curr.c, curr.dr, curr.dc, curr.steps
        dequeue!(pq)

        # found target, and have been moving for 4 steps so can stop
        # first encounter is optimal
        if (r, c) == (rows, cols) && steps ≥ 4 
            println(heatloss)
            break
        end

        # check if we've seen it before
        # note that loop would continuously increase heatloss, so don't include in seen state
        if (r, c, dr, dc, steps) ∈ visited
            continue
        else
            push!(visited, (r, c, dr, dc, steps)) # mark as seen
        end

        # if we've made less than 10 consecutive steps and are currently moving
        # we can continue moving
        if steps < 10 && (dr, dc) ≠ (0, 0)
            nr = r + dr
            nc = c + dc
            
            # boundary check
            if 1 ≤ nr ≤ rows && 1 ≤ nc ≤ cols

                new_node = node(nr, nc, dr, dc, steps + 1)
                new_heatloss = heatloss + grid[nr][nc]

                # if key exists, update it
                if haskey(pq, new_node)
                    if new_heatloss < pq[new_node]
                        ps[new_node] = new_heatloss
                    end
                # key doesn't exists, so just add it
                else
                    enqueue!(pq, new_node, new_heatloss)
                end
            end
        end

        # if moving for 4 consecutive steps
        # or at the start
        if steps ≥ 4 || (dr, dc) == (0, 0 )

            # try turning
            for (ndr, ndc) ∈ dirs
                # already checking straight moves above
                # cannot move directly backwards
                if (ndr, ndc) ≠ (dr, dc) && (ndr, ndc) ≠ (-dr, -dc)
                
                    nr = r + ndr
                    nc = c + ndc
                    
                    # boundary check
                    if 1 ≤ nr ≤ rows && 1 ≤ nc ≤ cols

                        new_node = node(nr, nc, ndr, ndc, 1)
                        new_heatloss = heatloss + grid[nr][nc]

                        # if key exists, update it
                        if haskey(pq, new_node)
                            if new_heatloss < pq[new_node]
                                ps[new_node] = new_heatloss
                            end
                        # key doesn't exists, so just add it
                        else
                            enqueue!(pq, new_node, new_heatloss)
                        end
                    end
                end
            end
        end
    end

end