# main function
function day1_part1()

    # read file
    file_path = "day1/day1.txt"
    file = open(file_path, "r")

    # store numeric parts as integers
    numeric_parts = Int[]

    # regex to match numeric parts
    regex = r"\d"

    # parse each line
    for line in eachline(file)

        # extract numeric part
        first_digit = parse(Int, match(r"\d", line).match)
        last_digit = parse(Int, match(r"\d", reverse(line)).match)
        push!(numeric_parts, first_digit*10+last_digit)
    end

    # close file
    close(file)

    # print result
    println(sum(numeric_parts))
end