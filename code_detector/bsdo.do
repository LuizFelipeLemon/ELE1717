vsim bs
add wave *

force clk 0 0, 1 37 us -repeat 74 us
force bt 0
run 200 ms

force bt 1
 run 100 ms 
