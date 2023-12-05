using DataStructures


# main function
function day5_part2()

    # read data
    lines = readlines("input/day5.txt")

    # get seed ranges
    seed_inputs = parse.(Int, split(split(lines[1], ": ")[2], " "))
    seed_ranges = Vector{Vector{Int}}()
    for i in 1:2:length(seed_inputs)
        push!(seed_ranges, [seed_inputs[i], seed_inputs[i] + seed_inputs[i+1]])
    end

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
        mapped_ranges = []

        while length(seed_ranges) > 0

            seed_start, seed_end = pop!(seed_ranges) # get seed range

            map_exists = false # assume map does not exists

            # loop through map range
            for (dest_start, source_start, len) in maps[map]

                # find range overlap
                overlap_start = max(seed_start, source_start)
                overlap_end = min(seed_end, source_start + len)

                # if overlap range is valid
                if overlap_start < overlap_end

                    map_exists = true

                    # map the overlap range
                    push!(mapped_ranges, [overlap_start - source_start + dest_start, overlap_end - source_start + dest_start])

                    # handle edges of seed range
                    # these are pushed to seed ranges as they can potentially still be mapped
                    if seed_start < overlap_start
                        push!(seed_ranges, [seed_start, overlap_start])
                    end
                    if overlap_end < seed_end
                        push!(seed_ranges, [overlap_end, seed_end])
                    end

                    break # move to next seed range

                end
            end

            # seed range not mapable, so append current
            if !map_exists
                push!(mapped_ranges, [seed_start, seed_end])
            end

        end

        # mapped seeds become new seeds
        seed_ranges = mapped_ranges

    end

    # print minimum seed value
    println(minimum(seed_ranges) do pair pair[1] end)

end