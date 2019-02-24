vsim mde_d
add wave *

force clk 0 0, 1 37 us -repeat 74 us
run 200 ms
force key "0111"

run 100 ms

force key "1101"

run 100 ms
 
force key "1110"

run 100 ms

force key "1011"

run 100 ms  

force key "1011"

run 100 ms

force key "1101"

run 300 ms

force key "1111"

run 200 ms
 
force sw 1 

run 200 ms
 