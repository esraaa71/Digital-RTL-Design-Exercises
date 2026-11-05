# Digital RTL Design Exercises (Verilog)

A curated collection of small educational RTL modules and testbenches extracted from the original coursework archive `KW.zip`. Original source files are preserved without functional corrections. This repository is a portfolio of **learning exercises**, not a set of silicon-qualified or exhaustively verified IP blocks.

## Contents

| Folder | Included exercises | Verification status / caveats |
|---|---|---|
| `01_Multiplexers_and_FlipFlops` | 3-input muxes implemented in two styles, enabled D flip-flop | Mux testbench included; FF testbench not provided |
| `02_Registered_ALU_and_Counter` | Small pipelined/registered ALU, 2-bit counter | ALU testbench included; check opcode alignment in RTL |
| `03_Parameterized_Logic_and_Storage` | Parameterized logic, flop/latch variants, demultiplexer | Selected testbenches; several units have no testbench |
| `04_Gray_and_OneHot_Coding` | 3-bit to Gray and one-hot lookup table | Two testbenches included; note output-width and semantics |
| `05_Arithmetic_Logic_Shift_Unit` | Configurable ALSU, testbench, constraints | Testbench needs more systematic assertions; XDC is board-specific |
| `06_Clock_Domain_Crossing` | Synchronizers, pulse toggle, Gray converter, controller/worker demonstration | Teaching examples only; not generic-safe arbitrary multibit CDC |
| `07_DSP48A1_Incomplete_Source` | DSP48A1 testbench | **DUT/source is missing**; retained as unfinished reference only |

## Run (where supported)

Open the folder for each exercise in ModelSim/Questa or another compatible Verilog simulator. Compile the RTL source file(s), then compile and run the matching testbench. Example using Icarus Verilog after installation:

```sh
iverilog -g2012 -s tb_MUX -o mux_sim projects/01_Multiplexers_and_FlipFlops/MUX1.v projects/01_Multiplexers_and_FlipFlops/MUX2.v projects/01_Multiplexers_and_FlipFlops/tb_MUX.v
vvp mux_sim
```

No fresh regression run is represented by this README. Inspect and improve benches before citing passing test counts.

## Known issues / future work

1. `lab3/ALU.v` registers `opcode_reg` but selects the result using the **unregistered** `opcode`, which can misalign the opcode with registered operands.
2. `task5/Worker.v` loads its counter while `cmd_valid` is high; `ctrl_ip` holds that signal high until done, so the worker may never decrement or signal completion. Review the handshake before claiming a functional mini-SoC.
3. `task5/Q3_gray_enc_sync.v` is not a generic CDC solution for arbitrary multibit updates. Gray coding only limits crossings when source transitions meet strict assumptions (for example, increment-by-one counters).
4. `task2/extra_1.v` outputs a 7-bit vector but Gray coding uses only 3 bits; the one-hot encoding of zero is all zeros. Document intended encoding, expand width to eight if conventional one-hot for eight symbols is desired, and fix tests accordingly.
5. The DSP48A1 DUT is absent; its testbench will not compile alone.
6. Some testbenches report completion without robust automated comparisons. Add assertions, expected models, and reproducible logs.

## Scope

The SPI/RAM systems and AXI4-Lite GPIO peripheral should live in separate repositories because they are larger, architecture-level projects. No claims of FPGA resource use or protocol compliance are made for these smaller exercises without corresponding reports.

## Attribution

This repository was reorganized from original coursework files. Add team/coauthor credits for any jointly completed exercises before public publication.
