vlib work
do design/compile_design.do
vlog  top_TB.v
vsim -voptargs=+acc work.top_TB
add wave *
add wave -position insertpoint  \
sim:/top_TB/reggit_top/reggit_slave/rx_data
add wave -position insertpoint  \
sim:/top_TB/reggit_top/reggit_slave/tx_data
add wave -position insertpoint  \
sim:/top_TB/reggit_top/reggit_ram/mem
run -all
#quit -sim