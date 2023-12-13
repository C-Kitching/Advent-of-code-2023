
# find mirror positions
function find_horizontal_mirror(block::Vector{Vector{Char}})

    # move mirror through all rows
    for mirror_pos in 2:length(block)

        # split block into top and bottom, reversing top
        top = reverse(block[1:mirror_pos-1])
        bottom = block[mirror_pos:end]

        # trim anything that is not in both
        min_range = min(length(bottom), length(top))
        top = top[1:min_range]
        bottom = bottom[1:min_range]

        # compare all elements
        if top == bottom
            return mirror_pos-1
        end
    end

    return 0
end

# transpose block
function transpose_vector_of_vectors(vov::Vector{Vector{Char}}) :: Vector{Vector{Char}}
    # Find the length of the longest inner vector
    max_length = maximum(length.(vov))

    # Initialize the result with empty vectors
    result = [Vector{Char}() for _ in 1:max_length]

    # Fill the result by swapping rows and columns
    for i in 1:max_length
        for vec in vov
            push!(result[i], vec[i])
        end
    end

    return result
end

# calculate result i.e v_mirror + 100*h_mirror
function calculate_result(blocks::Vector{Vector{Vector{Char}}}) :: Int

    # declare result
    res = 0

    # loop over each block
    for block in blocks
        res += 100*find_horizontal_mirror(block)
        res += find_horizontal_mirror(transpose_vector_of_vectors(block))
    end

    return res
end

# read data into container
function read_data(file_path::AbstractString) :: Vector{Vector{Vector{Char}}}
    
    file = open(file_path, "r")
    data = read(file, String)
    close(file)

    blocks_string = split(data, "\r\n\r\n")
    blocks = Vector{Vector{Vector{Char}}}()

    for block_string in blocks_string
        lines = split(block_string, "\r\n")
        push!(blocks, [collect(strip(line)) for line in lines])
    end

    return blocks
end

# main function
function day13_part1()

    # read data
    blocks = read_data("input/day13.txt")

    # calculate and print result
    res = calculate_result(blocks)
    println(res)

end