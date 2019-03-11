transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processador_4/register_bank.vhd}

vlog -vlog01compat -work work +incdir+/home/luiz/Documents/projects/ELE1717/processador_4/simulation/modelsim {/home/luiz/Documents/projects/ELE1717/processador_4/simulation/modelsim/register_bank.vt}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  testbench2

add wave *
view structure
view signals
run -all
