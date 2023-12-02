# main function
function day2_part2()

    # allowed number of cubes
    red_lim = 12
    green_lim = 13
    blue_lim = 14

    # read file
    file_path = "day2/day2.txt"
    lines = readlines(file_path)

    # total power of all games
    total_power = 0

    # handle each game
    for line in lines

        new_line = split(line, ": ")
        ID = parse(Int, split(new_line[1], " ")[end]) # extract ID
        rounds = split(new_line[2], "; ") # extract rounds

        min_r = min_g = min_b = 0 # initialise maximum for each game

        # parse each round
        for round in rounds

            r = g = b = 0
            colours_in_round = split(round, ", ") # extract full round

            # parse colours of each round
            for string in colours_in_round

                num, colour = split(string, " ") # extract number and colour of each cube in round

                # get integer number of cubes of that colour
                if colour == "red"
                    r = parse(Int, num)
                    min_r = max(r, min_r) # update max
                elseif colour == "green"
                    g = parse(Int, num)
                    min_g = max(g, min_g) # update max
                elseif colour == "blue"
                    b = parse(Int, num)
                    min_b = max(b, min_b) # update max
                end
            end
        end

        # calculte power of game
        power = min_r*min_g*min_b
        total_power += power
        
    end

    # print result
    println(total_power)

end