using DataStructures


# main function
function day5_part1()

    # read data
    lines = readlines("input/day5.txt")

    # get seed nums
    seeds = parse.(Int, split(split(lines[1], ": ")[2], " "))

    # dictionary for ranges
    maps = OrderedDict()
    map_name = ""

    # read ranges
    for line in lines[3:end]

        # line defining the map
        if endswith(line, " map:")
            map_name = chopsuffix(line, " map:")
            maps[map_name] = []
        # line containing map information
        elseif !isempty(line)
            (dest_start, source_start, len) = parse.(Int, split(line))
            push!(maps[map_name], [dest_start, source_start, len])
        end 
    end

    # go through each map
    for map in keys(maps)

        # new values after mapping seeds
        mapped_seeds = []

        # go through all seeds
        for seed in seeds

            map_exists = false # assume map does not exists

            # check all ranges in map
            for (dest_start, source_start, len) in maps[map]

                # if seed contained in range, map it to new value
                if (source_start <= seed <= source_start + len)
                    map_exists = true
                    push!(mapped_seeds, seed - source_start + dest_start)
                    break # move to next seed
                end
            end

            # seed not in any range, so maps to same value
            if !map_exists
                push!(mapped_seeds, seed)
            end
        end

        # mapped seeds become new seeds
        seeds = mapped_seeds

    end

    # print min value
    println(minimum(seeds))


end