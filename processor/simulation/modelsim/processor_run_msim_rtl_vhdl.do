transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/ram.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/reg.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/mux1.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/add.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/PC.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/SP.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/register_bank.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/B_ULA.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/mul.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/comp.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/datapath.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/control_block.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/processor.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/mux2.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/processor/ffd.vhd}

