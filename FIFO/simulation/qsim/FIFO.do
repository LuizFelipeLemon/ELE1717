onerror {quit -f}
vlib work
vlog -work work FIFO.vo
vlog -work work FIFO.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.FIFOM_vlg_vec_tst
vcd file -direction FIFO.msim.vcd
vcd add -internal FIFOM_vlg_vec_tst/*
vcd add -internal FIFOM_vlg_vec_tst/i1/*
add wave /*
run -all
