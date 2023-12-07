
# map picture cards to letters
letter_map = Dict('T'=>'A', 'J'=>'B', 'Q'=>'C', 'K'=>'D', 'A'=>'E')

# classify the hand as 5 of a kind, 4 of a kind, etc.
function classify(hand::String)
    counts = [count(card, hand) for card in hand]
    
    # 5 of a kind
    if 5 in counts
        return 6
    # 4 of a kind
    elseif 4 in counts
        return 5
    elseif 3 in counts
        # full house
        if 2 in counts
            return 4
        # 3 of a kind
        else
            return 3
        end
    # two pair
    elseif count(x -> x == 2, counts) == 4
        return 2
    # one pair
    elseif 2 in counts
        return 1
    # high card
    else
        return 0
    end

end

# compute strength of each hand
# first element is hand rank, i.e pair, 3 of a kind etc
# second element is string array where picture cards have been converted
function strength_of_hand(hand::String)
    strength = (classify(hand), [get(letter_map, char, char) for char in hand])
    return strength
end

# main function
function day7_part1()

    # read data
    lines = readlines("input/day7.txt")

    # containers
    hands = Pair{String, Int}[]

    # format each line
    for line in lines
        split_line = split(line)
        push!(hands, split_line[1] => parse(Int, split_line[2]))
    end

    # sort by hand
    sorted_hand = sort(hands, by = x -> strength_of_hand(x[1]))

    # compute total winnings
    total_winnings = 0
    for (i, hand) in enumerate(sorted_hand)
        total_winnings += i*hand[2]
    end

    println(total_winnings)

end