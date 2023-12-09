# packages
using Statistics

# apply alternating plus and minus to array
function alt_plus_minus(nums::Vector{Int}) :: Int
    res = nums[1]
    for i in 2:length(nums)
        res += (i%2 == 0 ? -nums[i] : nums[i])
    end
    return res
end

# main function
function day9_part2()

    # read data
    lines = readlines("input/day9.txt")

    res = 0 # store result

    # handle each line
    for line in lines
        nums = parse.(Int, split(line))

        start_nums = Int[] # track ending nums

        # reduce to all zeroes
        while !all(x -> x == 0, nums)
            push!(start_nums, nums[1])
            nums = diff(nums)
        end

        # increment result
        res += alt_plus_minus(start_nums)

    end

    # print result
    println(res)

end