
# imports
using DataStructures

# struct for module
mutable struct MyModule
    name::String
    type::Char
    outputs::Vector{String}
    memory::Union{String, Dict}

    # initialise module
    function MyModule(name::String, type::Char, outputs::Vector{String})
        memory = type == '%' ? "off" : Dict()
        new(name, type, outputs, memory)
    end
end

# custom show method for printing
function Base.show(io::IO, m::MyModule)
    outputs_str = join(m.outputs, ",")
    println(io, "$(m.name){type=$(m.type),outputs=$outputs_str,memory=$(m.memory)}")
end

# read in data
function read_data()

    modules = Dict{String, MyModule}()
    broadcast_targets = Vector{String}()

    for line in readlines("input/day20.txt")
        left, right = strip.(split(line, " -> "))
        outputs = [String(s) for s in split(right, ", ")]
        if left == "broadcaster"
            broadcast_targets = outputs
        else
            type = left[1]
            name = String(left[2:end])
            modules[name] = MyModule(name, type, outputs)
        end
    end

    # fill memory
    for (name, mod) ∈ pairs(modules)
        for output in mod.outputs
            if output ∈ keys(modules) && modules[output].type == '&'
                    modules[output].memory[name] = "low"
            end
        end
    end

    return modules, broadcast_targets

end

# perform logic and count low and high signals
function count_signals(modules::Dict{String, MyModule}, 
    broadcast_targets::Vector{String}, 
    button_pushes::Int) :: Tuple{Int, Int}

    low = high = 0

    for _ in 1:button_pushes

        low += 1 # initial press

        # q in the form (curr, dest, signal)
        q = Deque{Tuple{String, String, String}}()
        for target ∈ broadcast_targets
            push!(q, ("broadcaster", target, "low"))
        end

        # bfs
        while !isempty(q)

            # get next item
            curr, dest, signal = popfirst!(q)

            # count pulses
            if signal == "low"
                low += 1
            else
                high += 1
            end

            # if target not a module, no need to push new item
            if dest ∉ keys(modules)
                continue
            end

            # grab target
            dest_mod = modules[dest]

            # current mod is flip flop
            if dest_mod.type == '%'
                # only acts with a low signal
                if signal == "low"

                    # flip state
                    dest_mod.memory = dest_mod.memory == "off" ? "on" : "off" 

                    # on mods send high pulse, off sends low pulse
                    send_pulse = dest_mod.memory == "on" ? "high" : "low"

                    # send pulse to all outputs 
                    for output ∈ dest_mod.outputs
                        push!(q, (dest_mod.name, output, send_pulse))
                    end
                end
            # current module is conjunction
            else

                # update the most recent signal that came from curr mod
                dest_mod.memory[curr] = signal

                # if all most recent signals are high, send a low
                if all(last_pulse == "high" for last_pulse in values(dest_mod.memory))
                    send_pulse = "low"
                # else send a low
                else
                    send_pulse = "high"
                end

                # send pulse to all outputs
                for output ∈ dest_mod.outputs
                    push!(q, (dest_mod.name, output, send_pulse))
                end
            end
        end

    end

    return low, high

end

# main function
function day20_part1()

    # read data
    modules, broadcast_targets = read_data()

    # get low and high signal counts
    low, high = count_signals(modules, broadcast_targets, 1000)

    # print result
    println(low*high)

end