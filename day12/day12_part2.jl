
memory = Dict()

# count number of valid configurations
function count(config::AbstractString, nums::Tuple{Vararg{Int}}) :: Int

    # no springs left
    if config == ""
        # 1 valid config if not expecting more broken spring blocks
        # 0 not valid if nums not empty, so expecting more broken spring blocks but config is empty
        return isempty(nums) ? 1 : 0
    end

    # not expecting more springs
    if isempty(nums)
        # 0 not valid config if broken springs left but not expecting more broken springs
        # 1 valid config if no more broken springs
        return '#' ∈ config ? 0 : 1
    end

    # check memory for this configuration
    key = (config, nums)
    if haskey(memory, key)
        return memory[key]
    end

    result = 0

    # curr element is operational spring, remove and count again
    if config[1] ∈ ['.', '?']
        result += count(config[2:end], nums)
    end

    # curr element is broken spring, marks the start of a block of broken springs
    if config[1] ∈ ['#', '?']

        # check the block is valid
        # 1. remaining config must be at least as long as the next expected block
        # 2. there can be no operational springs over the next block length
        # 3. cannot have 2 consecutive blocks, i.e config is exactly the length of the next expected or next element after block is broken
        if nums[1] ≤ length(config) && '.' ∉ config[1:nums[1]] && (nums[1] == length(config) || config[nums[1]+1] ≠ '#')
            
            result += count(config[nums[1]+2:end], nums[2:end])
        end
    end

    # save result in memory
    memory[key] = result

    return result
end

# main function
function day12_part1()

    # read lines
    lines = readlines("input/day12.txt")

    res = 0

    # read in data
    for line in lines

        # read springs
        config = join(fill(split(line, " ")[1], 5), "?")

        # read nums part
        number_string = split(line, " ")[2]
        number_parts = split(number_string, ",")
        nums_arr = parse.(Int, number_parts)
        nums = Tuple(repeat(nums_arr, 5))

        # calculate possible configurations
        res += count(config, nums)

    end

    # print result
    println(res)

end