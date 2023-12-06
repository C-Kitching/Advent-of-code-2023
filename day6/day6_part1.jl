
# main function
function day6_part1()

    # read data
    lines = readlines("input/day6.txt")
    max_times = parse.(Int, split(strip(split(lines[1], ": ")[2])))
    record_dists = parse.(Int, split(strip(split(lines[2], ": ")[2])))

    # initalise final result
    res = 1

    # handle each race
    for i in 1:length(max_times)

        number_ways_to_win = 0

        # get race time and record dist
        max_time = max_times[i]
        record_dist = record_dists[i]

        # loop all possible button times
        for t in 0:max_time

            new_dist = max_time*t - t^2 # distance from this hold time

            # if beats record
            if new_dist > record_dist
                number_ways_to_win += 1
            end
        end

        # increment final result
        res *= number_ways_to_win

    end

    # print result
    println(res)

end