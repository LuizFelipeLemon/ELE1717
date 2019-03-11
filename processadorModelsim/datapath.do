
vsim datapath
add wave *

force clk 0 0, 1 37 us -repeat 74 us
run 200 ms