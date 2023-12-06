
# main function
function day6_part2_better()

    # read data
    lines = readlines("input/day6.txt")
    max_time = parse(Int, join(split(strip(split(lines[1], ": ")[2]))))
    record_dist = parse(Int, join(split(strip(split(lines[2], ": ")[2]))))

    # solve quadratic
    t_upper = floor((max_time + sqrt(max_time^2 - 4*record_dist))/2)
    t_lower = ceil((max_time - sqrt(max_time^2 - 4*record_dist))/2)

    # get and print result
    number_ways_to_win = (t_upper - t_lower) + 1
    println(Int(number_ways_to_win))

end
