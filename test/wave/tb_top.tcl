#python ../run.py --gtkwave-fmt vcd --gui lib.tb_collector.gtkw

set nfacts [ gtkwave::getNumFacs ]
puts "$nfacts"


for {set i 0} {$i < $nfacts} {incr i} {
    set name [gtkwave::getFacName $i]
    puts "$name"

    switch -glob -- $name {

        tb_lab1.clk -
        tb_lab1.rst -
        tb_lab1.expected_res -
        tb_lab1.data_parallel -
        tb_lab1.data_serial -
        tb_lab1.data_mealy -
        tb_lab1.data_moore -
        tb_lab1.data_valid -
        tb_lab1.data_valid_mealy -
        tb_lab1.data_valid_moore -
        tb_lab1.counter_mealy -
        tb_lab1.counter_moore -

        tb_tb.a* {
            gtkwave::addSignalsFromList "$name"
        }
    }
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full