
# main function
function day4_part1()

    # read data
    lines = readlines("day4/day4.txt")

    # record score
    score = 0

    # read each card  
    for line in lines

        # read nums off card
        nums = split(split(line, ": ")[2], "| ")
        winning_nums = parse.(Int, split(nums[1]))
        ticket_nums = parse.(Int, split(nums[2]))

        # find number of matches
        num_matches = length(intersect(winning_nums, ticket_nums))

        # increment score
        if num_matches != 0
            score += 2^(num_matches - 1)
        end

    end

    # print result
    println(score)

end