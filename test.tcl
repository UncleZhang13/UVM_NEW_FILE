set a {a b c d}

foreach i $a {
    puts $i
}

# set a 1
# proc sample {x} {
#     global a
#     set a [expr $a + 1]
#     return [expr $a + $x]
# }

# puts "x = [sample 3], a = $a"
