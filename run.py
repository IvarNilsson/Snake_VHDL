from pathlib import Path
import sys
sys.path.append("/usr/local/VUnit/vunit/")
#import vunit
from vunit import VUnit


# NOTE: Path to directory containing this file
ROOT = Path(__file__).parent

vu = VUnit.from_argv()  # Stop using the builtins ahead of time.vu.add_vhdl_builtins() #new for version 5 VUnit
#vu = VUnit.from_argv()  # Stop using the builtins ahead of time.vu.add_vhdl_builtins() #new for version 5 VUnit
#vu.set_sim_option('ghdl.gtkwave_script.gui', 'gtkWave.tcl')
vu.add_vhdl_builtins() #new for version 5 VUnit

lib = vu.add_library("lib")
lib.add_source_files(ROOT.glob("test/*.vhd"))
#lib.add_source_files(ROOT.glob("test/sample.vhd"))

#lib.add_source_files(ROOT.glob("src/**/*.vhd"))

lib.add_source_files(ROOT.glob("src/*.vhd"))
#lib.add_source_files(ROOT.glob("src/lab2/*.vhd"))
#lib.add_source_files(ROOT.glob("src/lab3/*.vhd"))
#lib.add_source_files(ROOT.glob("src/lib_vhd/*.vhd"))

#lib.add_source_files(ROOT.glob("src/lab2/*.vhd"))
#lib.add_source_files(ROOT.glob("src/lab3/*.vhd"))
#lib.add_source_files(ROOT.glob("src/simulated_array/*.vhd"))
#lib.add_source_files(ROOT.glob("src/matrix_package.vhd"))


for l in lib.get_test_benches():
   wave = ROOT.joinpath("test", "wave", f"{l.name}.tcl")
   l.set_sim_option("ghdl.gtkwave_script.gui", str(wave) if wave.is_file() else str(ROOT / "gtkwave.tcl"))
vu.main()


