

# read data in
function read_data()

    # read data
    data = split(read("input/day19.txt", String), "\r\n\r\n")
    rules_string, parts_string = split(data[1]), split(data[2])

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

    # handle parts
    parts = Vector{Dict}()
    for part_string in parts_string
        part = Dict() # dicts mapping 'x', 'm',... to their values
        catagories = split(part_string[2:end-1], ",")
        for item in catagories
            catagory, value = split(item, "=")
            part[catagory[1]] = parse.(Int, value)
        end
        push!(parts, part)
    end

    return workflows, parts

end

# determine if a part is accepted
function accept(part::Dict, workflows::Dict, curr::AbstractString) :: Bool
    
    # handle acceptance and rejection
    if curr == "R"
        return false
    end
    if curr == "A"
        return true
    end

    # get workflow and fallback
    workflow, fallback = workflows[curr]

    # parse the workflow
    for rules in workflow

        rule_cat = rules[1] # rule catagory
        rule_val = rules[3] # rule value
        rule_dest = rules[4] # destination
        part_val = part[rule_cat] # part value

        # pass that rule
        if (rules[2] == '>' && part_val > rule_val) || (rules[2] == '<' && part_val < rule_val)
            return accept(part, workflows, rule_dest)
        end
    end

    # go to the fallback
    return accept(part, workflows, fallback)

end

# main function
function day19_part1()

    # read data
    workflows, parts = read_data() 

    total_rating = 0

    # go through each part
    for part in parts

        # if part is accepted, calculate total rating
        if accept(part, workflows, "in")
            total_rating += sum(values(part))
        end
    end

    # print result
    println(total_rating)

end