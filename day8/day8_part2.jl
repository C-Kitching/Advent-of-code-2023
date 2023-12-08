
# find GCD of two numbers
function find_GCD(a, b)
    if b == 0
        return a
    end
    return find_GCD(b, a%b)
end

# find LCM of a list of numbers
function find_LCM(nums)
    curr_lcm = nums[1]
    for i in 2:length(nums)
        curr_lcm = (nums[i]*curr_lcm)/find_GCD(nums[i], curr_lcm)
    end
    return Int(curr_lcm)
end

# main function
function day8_part2()

    # read data
    lines = readlines("input/day8.txt")

    # extract directions
    dir = lines[1]
    dir = replace(replace(dir, 'L' => '1'), 'R' => '2')
    len_dir = length(dir)
    
    # initialise graph
    graph = Dict{String, Tuple{String, String}}()

    # starting nodes
    curr_nodes = String[]

    # read graph
    for i in 3:length(lines)
        source = split(lines[i], " = ")[1]
        dests = split(split(lines[i], " = ")[2][2:end-1], ',')
        graph[source] = (strip(dests[1]), strip(dests[2]))

        # node ending in A
        if source[end] == 'A'
            push!(curr_nodes, source)
        end
    end

    # number of steps to reach Z node
    distances = Int[]

    # search graph
    for curr in curr_nodes


        steps = counter = 1
        while curr != "ZZZ"

            # move to next pos
            curr = graph[curr][parse.(Int,dir[counter])]

            # check if ending Z
            if curr[end] == 'Z'
                break
            end

            steps += 1 # next step
            counter += 1 # new direction

            # loop through directions
            if counter > len_dir
                counter = 1
            end
        end

        # store number of steps
        push!(distances, steps)

    end

    # find LCM
    LCM = find_LCM(distances)
    println(LCM)

end