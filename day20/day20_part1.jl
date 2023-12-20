
# imports
using DataStructures

# read data in
function read_data()

    flip_flop_mods = Dict{String, Vector{String}}()
    conjunction_mods = Dict{String, Vector{String}}()
    broadcaster = Vector{String}()

    lines = readlines("input/day20_test1.txt")
    for line in lines

        # flip flop
        if line[1] == '%'
            curr = split(line, " ->")[1][2:end]
            flip_flop_mods[curr] = split(split(line, "-> ")[2], ", ")

        # conjunction
        elseif line[1] == '&'
            curr = split(line, " ->")[1][2:end]
            conjunction_mods[curr] = split(split(line, "-> ")[2], ", ")

        # broadcast
        else
            broadcaster = map(String, split(split(line, "-> ")[2], ", "))
        end

    end

    return flip_flop_mods, conjunction_mods, broadcaster

end

# initialise conjunction memory
function initialise_conjunction_memory(
    flip_flop_mods::Dict{String, Vector{String}}, 
    conjunction_mods::Dict{String, Vector{String}}, 
    broadcaster::Vector{String}) :: Dict{String, Dict{String, String}}

    conjunction_input = Dict{String, Dict{String, String}}()
    for dest in broadcaster
        if dest in keys(conjunction_mods)
            if dest in keys(conjunction_input)
                conjunction_input[dest]["broadcaster"] = "low"
            else
                conjunction_input[dest] = Dict("broadcaster" => "low")
            end
        end
    end
    for flip_flop_mod in keys(flip_flop_mods)
        for dest in flip_flop_mods[flip_flop_mod]
            if dest in keys(conjunction_mods)
                if dest in keys(conjunction_input)
                    conjunction_input[dest][flip_flop_mod] = "low"
                else
                    conjunction_input[dest] = Dict(flip_flop_mod => "low")
                end
            end
        end
    end
    for conjunction_mod in keys(conjunction_mods)
        for dest in conjunction_mods[conjunction_mod]
            if dest in keys(conjunction_mods)
                if dest in keys(conjunction_input)
                    conjunction_input[dest][conjunction_mode] = "low"
                else
                    conjunction_input[dest] = Dict(conjunction_mod => "low")
                end
            end
        end
    end

    return conjunction_input

end

# perform logic to count pulses
function count_pulses(
    flip_flop_mods::Dict{String, Vector{String}}, 
    conjunction_mods::Dict{String, Vector{String}}, 
    broadcaster::Vector{String},
    conjunction_input::Dict{String, Dict{String, String}},
    flip_flop_states::Dict{String, Int}, max_pushes::Int) :: Tuple{Int, Int}

    total_low = total_high = 0 # total pushes

    # push button however many times
    for i in 1:max_pushes

        # destination, signal type
        q = Deque{Tuple{String, String}}() 
        push!(q, ("broadcaster", "low"))

        # count low and high pulses
        low_pulses = 1 # button press
        high_pulses = 0

        # bfs
        while !isempty(q)

            # get next item
            curr, signal = popfirst!(q)

            # broadcast signal
            if curr == "broadcaster"
                for dest in broadcaster
                    push!(q, (dest, signal))
                end

                # update counts
                if signal == "low"
                    low_pulses += length(broadcaster)
                else
                    high_pulses += length(broadcaster)
                end

            # flip flop mod
            elseif curr in keys(flip_flop_mods)

                # flip state if low signal
                if signal == "low"

                    # on, turn off and send low
                    if flip_flop_states[curr] == 1
                        for dest in flip_flop_mods[curr]
                            push!(q, (dest, "low"))

                            # if dest is a conjunction mod, then update memory
                            if dest in keys(conjunction_mods)
                                conjunction_input[dest][curr] = "low"
                            end

                        end

                        # update counts
                        low_pulses += length(flip_flop_mods[curr])

                    # off, turn on and send high
                    else
                        for dest in flip_flop_mods[curr]
                            push!(q, (dest, "high"))

                            # if dest is a conjunction mod, then update memory
                            if dest in keys(conjunction_mods)
                                conjunction_input[dest][curr] = "high"
                            end

                        end

                        # update counts
                        high_pulses += length(flip_flop_mods[curr])

                    end

                    # flip state
                    flip_flop_states[curr] *= -1

                end

            # conjunction mod
            else 

                # if all memory is high, send low
                if all(state == "high" for state in values(conjunction_input[curr]))
                    for dest in conjunction_mods[curr]
                        push!(q, (dest, "low"))

                        # update counts
                        low_pulses += length(conjunction_mods[curr])

                    end
                # if all memory is low, send high
                else
                    for dest in conjunction_mods[curr]
                        push!(q, (dest, "high"))

                        # update counts
                        high_pulses += length(conjunction_mods[curr])

                    end
                end
            end
        end

        # track counts
        total_low += low_pulses
        total_high += high_pulses

        # if back to starting state
        if (all(state == 1 for state in values(flip_flop_states)) 
            && all(all(value == "low" for (_, value) in d) for (_, d) in conjunction_input))
            break
        end
        
    end

    return total_low, total_high

end

# main function
function day20_part1()

    # read data
    flip_flop_mods = Dict{String, Vector{String}}()
    conjunction_mods = Dict{String, Vector{String}}()
    broadcaster = Vector{String}()
    flip_flop_mods, conjunction_mods, broadcaster = read_data()

    # initalise memory of conjunction mods
    conjunction_input = Dict{String, Dict{String, String}}()
    conjunction_input = initialise_conjunction_memory(
        flip_flop_mods, conjunction_mods, broadcaster)

    # initalise all flip flops as off
    flip_flop_state = Dict{String, Int}()
    for mod in keys(flip_flop_mods)
        flip_flop_state[mod] = -1
    end

    # perform button pushes
    low_pulses, high_pulses = count_pulses(flip_flop_mods, conjunction_mods, 
    broadcaster, conjunction_input, flip_flop_state, 1000) 

    # print result
    println(low_pulses*high_pulses)

end

day20_part1()