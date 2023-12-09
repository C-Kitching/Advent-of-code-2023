# packages
using Statistics

# main function
function day9_part1()

    # read data
    lines = readlines("input/day9.txt")

    res = 0 # store result

    # handle each line
    for line in lines
        nums = parse.(Int, split(line))

        end_nums = Int[] # track ending nums

        # reduce to all zeroes
        while !all(x -> x == 0, nums)
            push!(end_nums, nums[end])
            nums = diff(nums)
        end

        # increment result
        res += sum(end_nums)

    end

    # print result
    println(res)

end