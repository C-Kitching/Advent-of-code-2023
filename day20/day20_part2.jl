
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

# find GCD of two numbers
function find_GCD(a::Int, b::Float64) :: Float64
    if b == 0
        return a
    end
    return find_GCD(b, a%b)
end

# find LCM of a list of numbers
function find_LCM(nums::Vector{Int}) :: Int
    curr_lcm = nums[1]
    for i in 2:length(nums)
        curr_lcm = (nums[i]*curr_lcm)/find_GCD(nums[i], curr_lcm)
    end
    return Int(curr_lcm)
end

# perform logic and count button presses
function count_presses(modules::Dict{String, MyModule}, 
    broadcast_targets::Vector{String}) :: Int

    # find mod that feeds into "rx"
    (feed, ) = [name for (name, mod) in pairs(modules) if "rx" in mod.outputs]

    # store cycle lengths
    cycle_lengths = Dict()

    # count how many times we see the module feeding high pulses into the feed module
    seen = Dict(name => 0 for (name, mod) in pairs(modules) if feed in mod.outputs)

    presses = 0
    while true
        presses += 1

        # q in the form (curr, dest, signal)
        q = Deque{Tuple{String, String, String}}()
        for target ∈ broadcast_targets
            push!(q, ("broadcaster", target, "low"))
        end

        # bfs
        while !isempty(q)

            # get next item
            curr, dest, signal = popfirst!(q)

            # if target not a module, no need to push new item
            if dest ∉ keys(modules)
                continue
            end

            # grab target
            dest_mod = modules[dest]

            # high pulse sent to feed
            if dest_mod.name == feed && signal == "high"
                seen[curr] += 1

                # assume the first time we see is a cycle
                if curr ∉ keys(cycle_lengths)
                    cycle_lengths[curr] = presses
                # otherwise confirm this is indeed a cycle
                else
                    @assert presses == seen[curr] * cycle_lengths[curr]
                end

                # found all cycles
                if all(x != 0 for x in values(seen))

                    # find lcm
                    vals = [x for x in values(cycle_lengths)]
                    lcm = find_LCM(values(vals))
                    return lcm
                end
            end

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
function day20_part2()

    # read data
    modules, broadcast_targets = read_data()

    # get low and high signal counts
    presses = count_presses(modules, broadcast_targets)

    # print result
    println(presses)

end