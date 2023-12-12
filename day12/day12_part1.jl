
# count number of valid configurations
function count(config::Vector{Char}, nums::Tuple{Int}) :: Int

    # no springs left
    if config == ""
        # 1 valid config if not expecting more nums
        # 0 if nums not empty, so expecting more springs but no springs left
        return nums == () ? 1 : 0
    end

    # not expecting more springs
    if nums == ()
        # 0 valid config if springs left but not expecting more springs
        # 1 valid config if no more springs
        return '#' ∈ config ? 0 : 1
    end

end

# main function
function day12_part1()

    # read lines
    lines = readlines("input/day12_test1.txt")

    res = 0

    # read in data
    for line in lines

        # read springs
        config = collect(line)

        # read nums part
        number_string = split(line, " ")[2]
        number_parts = split(number_string, ",")
        nums = Tuple(map(x -> parse(Int, x), number_parts))

        # calculate possible configurations
        res += count(config, nums)

    end

    # print result
    println(res)

end

day12_part1()