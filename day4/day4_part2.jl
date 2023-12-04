
# main function
function day4_part2()

    # read data
    lines = readlines("day4/day4.txt")

    # track amount of each card we have
    num_cards = length(lines)
    card_amounts = fill(1, num_cards) # initially have one of each card

    # read each card  
    for (i, line) in enumerate(lines)

        # read nums off card
        nums = split(split(line, ": ")[2], "| ")
        winning_nums = parse.(Int, split(nums[1]))
        ticket_nums = parse.(Int, split(nums[2]))

        # find number of matches
        num_matches = length(intersect(winning_nums, ticket_nums))

        # incrememnt card numbers
        for j in i+1:i+num_matches

            # ensure within bounds
            if j <= num_cards 
                card_amounts[j] += card_amounts[i]
            end
        end
    end

    # print result
    println(sum(card_amounts))

end