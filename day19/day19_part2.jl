

# read data in
function read_data()

    # read data
    data = split(read("input/day19.txt", String), "\r\n\r\n")
    rules_string = split(data[1])

    # handle rules
    workflows = Dict()
    for rule_string in rules_string
        node, rest = split(rule_string, "{")[1],  split(split(rule_string, "{")[2][1:end-1], ",")
        fallback = rest[end] # default destination

        # build rules as (catagory, comparison operator, value, destination)
        rules = Vector{Tuple{Char, Char, Int, String}}()
        for s in rest[1:end-1]
            comparison, target = split(s, ':')
            catagory = comparison[1]
            comparison_op = comparison[2]
            value = parse.(Int, comparison[3:end])
            push!(rules, (catagory, comparison_op, value, target))
        end

        workflows[node] = (rules, fallback)
    end

    return workflows

end

# count the number of valid ranges, given initial starting point and ranges
function count(ranges::Dict, workflows::Dict, curr::AbstractString) :: Int

    # handle reject and accept
    if curr == "R"
        return 0
    end
    if curr == "A"
        res = 1
        for range in values(ranges)
            res *= range[2] - range[1] + 1
        end
        return res
    end

    # get workflow and fallback
    workflow, fallback = workflows[curr]

    # track total as we do multiple recursions
    total = 0

    # go through the workflow
    covered = false
    for (cata, comp, val, dest) in workflow

        low, high = ranges[cata] # current ranges for that catagory

        # workflow bounds from above
        if comp == '<'
            true_part = (low, val - 1)
            false_part = (val, high)
        # workflow bounds from below
        else
            true_part = (val + 1, high)
            false_part = (low, val)
        end

        # if true part valid, move deeper
        if true_part[1] ≤ true_part[2]
            copy_ranges = Dict(ranges)
            copy_ranges[cata] = true_part
            total += count(copy_ranges, workflows, dest)
        end
        # false part valid, update ranges for next workflow
        if false_part[1] ≤ false_part[2]
            ranges = Dict(ranges)
            ranges[cata] = false_part
        # false empty, so all ranges covered by the rules in the workflow
        else
            covered = true
            break
        end
    end

    # rules did not cover all ranges, so go to fallback
    if !covered
        total += count(ranges, workflows, fallback)
    end

    return total

end

# main function
function day19_part2()

    # read data
    workflows = read_data() 

    # initalise range of possible values each catagory can take
    ranges = Dict(cata => (1, 4000) for cata in "xmas")

    # count valid ranges
    valid_ranges = count(ranges, workflows, "in")

    # print result
    println(valid_ranges)

end