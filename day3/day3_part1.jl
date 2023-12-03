
# main function
function day3_part1()

    # read data
    lines = readlines("day3/day3.txt")

    # valid directions
    directions = [[1,0], [0,1], [-1,0], [0,-1], [1,1], [-1,-1], [1,-1], [-1, 1]]

    sum_part_nums = 0
    num = 0
    valid_part_number = false

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

                num = 0 # reset number
            
            end
        end
    end

    # print result
    println(sum_part_nums)

end