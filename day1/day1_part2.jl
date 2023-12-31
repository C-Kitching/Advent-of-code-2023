# recursive function to convert words to numbers
function replace_words_with_numbers(s::AbstractString)
    s = replace(s,
        "twone" => "twoone",
        "oneight" => "oneeight",
        "threeight" => "threeeight",
        "fiveight" => "fiveeight",
        "sevenine" => "sevennine",
        "eightwo" => "eighttwo",
        "eighthree" => "eightthree")
    return replace(s,
        "one" => "1",
        "two" => "2",
        "three" => "3",
        "four" => "4",
        "five" => "5",
        "six" => "6",
        "seven" => "7",
        "eight" => "8",
        "nine" => "9")
end

# function to combine first and last element in string
firstLast(s::AbstractString) =  s[1] * s[end]

# main function
function day1_part2()
    
    # read file
    file_path = "day1/day1.txt"
    file = open(file_path, "r")

    # store numeric parts as integers
    numeric_parts = Int[]

    # parse each line
    for line in eachline(file)

        # convert all words to numbers if part 2
        # do nothing for part 1
        part2 = false
        modifier = part2 ? replace_words_with_numbers : identity
        line_as_numbers = modifier(line)

        # get string list of digitis
        digit_list = String([x for x in line_as_numbers if isdigit(x)])

        # get first and last numbers
        num = parse(Int, firstLast(digit_list))
        
        # store number
        push!(numeric_parts, num)
        
    end

    # close file
    close(file)

    # print result
    println(sum(numeric_parts))

end


