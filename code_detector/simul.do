vsim CLK_Div
add wave *

force clk_in 0 0, 1 37 ns -repeat 74 ns

run 200 ms