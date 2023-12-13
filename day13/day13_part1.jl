
function find_mirror(block::Vector{Vector{Char}})

    # move mirror through all rows
    for mirror_pos in 2:length(blocks)

        # split block into top and bottom, reversing top
        top = reverse(block[1:mirror_pos-1])
        bottom = [mirror_pos:end]

        # trim anything that is not in both
        top = top[1:length(bottom)]
        bottom = bottom[1:length(top)]

        # compare all elements
        for i in eachindex(top)
            for j in eachindex(bottom)
                if top[i][j] ≠ bottom[i][j]
                    break
                end
            end
        end

        # mirror found
        return mirror_pos

    end

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
    blocks = read_data("input/day13_test.txt")

    


end

day13_part1()