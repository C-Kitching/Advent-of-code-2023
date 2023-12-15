
# fun HASH algo
function hash_algo(s::AbstractString) :: Int

    res = 0
    for char in s
        res += Int(char)
        res *= 17
        res %= 256
    end

    return res

end

# calculate total focusing power
function calc_total_focusing_power(boxes::Vector{Vector{Pair{String, Int}}}) :: Int

    res = 0

    for (i, box) in enumerate(boxes)
        for (j, lens) in enumerate(box)
            res += i * j * lens[2]
        end
    end

    return res

end

# main function
function day15_part2()

    # read data
    file = read("input/day15.txt", String)
    lenses = split(file, ",")

    # initialise containers
    boxes = [Vector{Pair{String, Int}}() for _ in 1:256]

    # handle each lense
    for lens in lenses

        # extract infor of each lens
        delimeter = occursin('-', lens) ? '-' : '='
        parts = split(lens, delimeter)
        if delimeter == '-'
            label = parts[1]
        else
            label, focal_length = parts[1], parse(Int, parts[2])
        end
        
        # determine which box
        box_index = hash_algo(label)+1

        if delimeter == '-'
            # if any lens with that label
            filter!(pair -> pair[1] != label, boxes[box_index])
        else

            # if any lens with that label replace it
            if any(pair -> pair[1] == label, boxes[box_index])
                 # Replace it
                boxes[box_index] = [(pair[1] => pair[1] == label ? focal_length : pair[2]) for pair in boxes[box_index]]
            else
                # No lens with that label, so add to box
                push!(boxes[box_index], (label => focal_length))
            end

        end
    end

    # calculate and print result
    total_focusing_power = calc_total_focusing_power(boxes)
    println(total_focusing_power)

end