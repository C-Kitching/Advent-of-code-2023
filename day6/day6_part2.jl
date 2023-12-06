
# main function
function day6_part2()

    # read data
    lines = readlines("input/day6.txt")
    max_time = parse(Int, join(split(strip(split(lines[1], ": ")[2]))))
    record_dist = parse(Int, join(split(strip(split(lines[2], ": ")[2]))))

    number_ways_to_win = 0

    # loop all possible button times
    for t in 0:max_time

        new_dist = max_time*t - t^2 # distance from this hold time

        # if beats record
        if new_dist > record_dist
            number_ways_to_win += 1
        end
    end

    # print result
    println(number_ways_to_win)

end