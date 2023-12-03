
# main function
function day3_part2()

    # read data
    lines = readlines("day3/day3.txt")

    # valid directions
    directions = [[1,0], [0,1], [-1,0], [0,-1], [1,1], [-1,-1], [1,-1], [-1, 1]]

    sum_part_nums = 0
    num = 0
    valid_part_number = false
    gear_index = []
    gears = Dict()

    # go through each line
    for (i, line) in enumerate(lines)
        # go through each char
        for (j, char) in enumerate(line)

            # number found
            if isdigit(char)
                num = num*10 + parse(Int, char) # build number

                # check adjacent chars
                for dir in directions

                    try 
                        adj_char = lines[i + dir[1]][j + dir[2]]
                        
                        # non '.' symbol found
                        if adj_char != '.' && !isdigit(adj_char)
                            valid_part_number = true

                            # gear found
                            if adj_char == '*'
                                gear_index = [i + dir[1], j + dir[2]]
                            end
                        end

                    # index potentially out of bounds if we are on edge
                    catch
                        continue
                    end
                end

            # end of number or line
            elseif (!isdigit(char) || j == length(l) - 1)

                # last number found was a valid part number
                if valid_part_number
                    sum_part_nums += num
                    valid_part_number = false # reset for next number
                end

                # if a gear was found while parsing last number
                if length(gear_index) != 0
                    push!(get!(gears, gear_index, Vector{Int}()), num) # add to dictionary
                    gear_index = [] # reset for next number
                end

                num = 0 # reset number
            
            end
        end
    end

    total_gear_ratio = 0
    # go through all gears
    for (gear_index, gear_nums) in gears
        # exactly two part numbers
        if length(gear_nums) == 2
            total_gear_ratio += prod(gear_nums) # add gear ratio
        end
    end

    # print result
    println(total_gear_ratio)

end