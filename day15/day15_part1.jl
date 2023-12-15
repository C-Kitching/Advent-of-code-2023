

# main function
function day15_part1()

    # read data
    file = read("input/day15.txt", String)
    data = split(file, ",")

    # calculate result
    algo_results = Vector{Int}()
    for item in data
        res = 0
        for char in item
            res += Int(char)
            res *= 17
            res %= 256
        end
        push!(algo_results, res)
    end

    # print result
    res = sum(algo_results)
    println(res)

end