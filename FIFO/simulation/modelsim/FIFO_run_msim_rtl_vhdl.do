transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/counter.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/comapare.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/register_bank.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/FIFO.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/ffd.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/rom.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/FIFOM.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/DIV.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/BIN-BCD.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/seg7.vhd}
vcom -93 -work work {/home/luiz/Documents/projects/ELE1717/FIFO/counterROM.vhd}

