# main function
function day2_part1()

    # allowed number of cubes
    red_lim = 12
    green_lim = 13
    blue_lim = 14

    # read file
    file_path = "day2/day2.txt"
    lines = readlines(file_path)

    # sum of IDs of possible games
    possible_game_ids = 0

    # handle each game
    for line in lines

        new_line = split(line, ": ")
        ID = parse(Int, split(new_line[1], " ")[end]) # extract ID
        rounds = split(new_line[2], "; ") # extract rounds

        possible = true # assume that this round is true

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
                elseif colour == "green"
                    g = parse(Int, num)
                elseif colour == "blue"
                    b = parse(Int, num)
                end
            end

            # encountered an impossible round so move to next game
            if r > red_lim || g > green_lim || b > blue_lim
                possible = false
                break
            end
        end

        # found a possible game
        if possible
            possible_game_ids += ID
        end
    end

    # print result
    println(possible_game_ids)

end