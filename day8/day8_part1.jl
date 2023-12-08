

# main function
function day8_part1()

    # read data
    lines = readlines("input/day8.txt")

    # extract directions
    dir = lines[1]
    dir = replace(replace(dir, 'L' => '1'), 'R' => '2')
    len_dir = length(dir)
    
    # initialise graph
    graph = Dict{String, Tuple{String, String}}()

    # read graph
    for i in 3:length(lines)
        source = split(lines[i], " = ")[1]
        dests = split(split(lines[i], " = ")[2][2:end-1], ',')
        graph[source] = (strip(dests[1]), strip(dests[2]))
    end

    # search graph
    curr = "AAA"
    steps = counter = 1
    while curr != "ZZZ"

        # move to next pos
        curr = graph[curr][parse.(Int,dir[counter])]

        steps += 1 # next step
        counter += 1 # new direction

        # loop through directions
        if counter > len_dir
            counter = 1
        end

    end

    # print result
    println(steps - 1)

end