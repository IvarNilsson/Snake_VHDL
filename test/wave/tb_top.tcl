#python ../run.py --gtkwave-fmt vcd --gui lib.tb_collector.gtkw

set nfacts [ gtkwave::getNumFacs ]
puts "$nfacts"


for {set i 0} {$i < $nfacts} {incr i} {
    set name [gtkwave::getFacName $i]
    puts "$name"

    switch -glob -- $name {

        tb_top.clk_100 -
        tb_top.clk_25 -
        tb_top.rst -
        tb_top.game_tick_edge -

        tb_tb.a* {
            gtkwave::addSignalsFromList "$name"
        }
    }
}

# zoom full
gtkwave::/Time/Zoom/Zoom_Full
