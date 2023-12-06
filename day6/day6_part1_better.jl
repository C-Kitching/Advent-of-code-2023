
# main function
function day6_part1_better()

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

        # solve quadratic
        t_upper = floor((max_time + sqrt(max_time^2 - 4*record_dist))/2)
        t_lower = ceil((max_time - sqrt(max_time^2 - 4*record_dist))/2)

        # increment result
        res *= (t_upper - t_lower) + 1

    end

    # print result
    println(Int(res))

end