vcom -work work fir_filter.vhd
vcom -work work fir_filter_tb.vhd
vsim work.fir_filter_tb
add wave sim:/fir_filter_tb/UUT/*
run 1200 us