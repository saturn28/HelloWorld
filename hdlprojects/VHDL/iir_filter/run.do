vcom -work work ../fir_filter/shiftnmult.vhd
vcom -work work ../fir_filter/adder.vhd
vcom -work work iir_filter.vhd
vcom -work work iir_filter_tb.vhd
vsim work.iir_filter_tb
add wave sim:/iir_filter_tb/UUT/*
run 120000 us