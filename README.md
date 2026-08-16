# Matrix Multiplication Accelerator — RTL2GDS

A matrix multiplication accelerator implemented through a complete RTL-to-GDS digital IC design flow using Synopsys VCS, Design Compiler, and IC Compiler II with the SAED32 32 nm technology.


## Project Overview

This project demonstrates the implementation of a hardware matrix multiplication accelerator from RTL design through physical design.

The complete flow consists of:

1. RTL design
2. RTL functional verification using Synopsys VCS
3. Waveform inspection using Synopsys DVE
4. Logic synthesis using Synopsys Design Compiler
5. Floorplanning using Synopsys IC Compiler II
6. Power planning
7. Placement
8. Clock-tree synthesis and analysis
9. Routing
10. Filler-cell insertion
11. Power/ground connectivity checks
12. Physical-design and signoff-oriented report analysis

The design uses the SAED32 RVT standard-cell library at the operating condition of 0.85 V and 25 °C.


## Design Description

The project implements a hardware matrix multiplication accelerator.

The RTL accepts two packed input matrices and produces a packed matrix multiplication result.

The main matrix signals used by the design are:

- `MatrixA` — input matrix A
- `MatrixB` — input matrix B
- `MatrixC` — output matrix C
- `Clock` — system clock
- `Reset` — reset input
- `Start` — starts the matrix multiplication operation
- `Done` — indicates completion of the operation

The implementation includes:

- Matrix input handling
- Matrix multiplication
- Sequential control
- Clocked operation
- Reset handling
- Start control
- Completion indication
- Result generation


## Matrix Configuration

The accelerator operates on packed 3×3 matrix data.

The input and output interfaces are represented as packed vectors:

| Signal | Width | Description |
|---|---:|---|
| `MatrixA` | 36 bits | Input matrix A |
| `MatrixB` | 36 bits | Input matrix B |
| `MatrixC` | 72 bits | Matrix multiplication result |
| `Clock` | 1 bit | System clock |
| `Reset` | 1 bit | Reset |
| `Start` | 1 bit | Operation start |
| `Done` | 1 bit | Operation completion |

The testbench includes helper functions for packing matrix values into the corresponding RTL input vectors and checking the resulting output.


## Repository Structure

```text
Matrix-Multiplication-Accelerator-RTL2GDS/
│
├── README.md
│
├── vcs/
│   ├── README.md
│   ├── mma.v
│   └── tb_mma_compare.sv
│
├── dc/
│   ├── README.md
│   ├── source/
│   ├── scripts/
│   ├── reports/
│   ├── results/
│   └── work/
│
├── icc2/
│   ├── README.md
│   ├── source/
│   ├── scripts/
│   ├── reports/
│   ├── results/
│   └── work/
│
├── ref/
│   ├── README.md
│   ├── lib/
│   │   └── README.md
│   └── tech/
│       └── README.md
│
└── images/
    ├── README.md
    └── screenshots/
```


# RTL Functional Verification

RTL functionality was verified before synthesis using Synopsys VCS and a SystemVerilog comparison testbench.

The testbench is:

```text
vcs/tb_mma_compare.sv
```

The testbench instantiates the matrix multiplication accelerator and compares the DUT result against the expected matrix multiplication result.

The verification flow includes:

- Reset verification
- Matrix input application
- Start control
- Matrix multiplication operation
- Result comparison
- Completion detection
- Multiple matrix test cases


### VCS Compilation

Run the VCS compilation from the `vcs` directory using the project files:

```bash
vcs -full64 -sverilog -debug_all mma.v tb_mma_compare.sv -l compile_rtl.log
```


### Simulation

Run the generated simulation executable:

```bash
./simv -l sim_rtl.log
```


### DVE Waveform Analysis

The waveform generated during VCS simulation can be inspected using Synopsys DVE.

Typical launch command:

```bash
dve -full64 -vpd mma_compare.vpd &
```

The waveform is used to inspect:

- Clock
- Reset
- Start
- Matrix A
- Matrix B
- Matrix C
- Done

The DVE environment provides visual confirmation of the matrix inputs, operation control, result generation, and completion indication.


# RTL-to-GDS Flow

```text
                     RTL Design
                         │
                         ▼
              VCS Functional Verification
                         │
                         ▼
                   DVE Waveform
                       Analysis
                         │
                         ▼
                  Design Compiler
                         │
              ┌──────────┼──────────┐
              ▼          ▼          ▼
            Timing      Area       Power
              │          │          │
              └──────────┼──────────┘
                         ▼
                       ICC2
                         │
                         ▼
                    Floorplanning
                         │
                         ▼
                   Power Planning
                         │
                         ▼
                     Placement
                         │
                         ▼
                Clock Tree Synthesis
                         │
                         ▼
                      Routing
                         │
                         ▼
                  Filler Insertion
                         │
                         ▼
             PG Connectivity / Repair
                         │
                         ▼
                  Final Reports
                         │
                         ▼
                Final Physical Design
```


# Design Compiler — Logic Synthesis

The verified RTL is synthesized using Synopsys Design Compiler.

The synthesis flow performs:

- RTL elaboration
- Technology mapping
- Constraint application
- Logic optimization
- Timing analysis
- Area analysis
- Power analysis
- QoR analysis
- Report generation

The Design Compiler files are organized under:

```text
dc/
```

The synthesis scripts are stored under:

```text
dc/scripts/
```

Source RTL and constraint files are stored under:

```text
dc/source/
```

Generated synthesis reports are stored under:

```text
dc/reports/
```

Generated synthesis results are stored under:

```text
dc/results/
```


### DC Launch

From the Design Compiler working directory:

```bash
dc_shell -gui
```

Then source the synthesis script used by the project:

```tcl
source ../scripts/<synthesis_script>.tcl
```


### Synthesis

The synthesis flow performs RTL elaboration, technology mapping, optimization, constraint application, and report generation.

The synthesis process evaluates the design for timing, area, power, and overall quality of results.


### Main DC Reports

The synthesis flow generates reports covering:

- Area
- Power
- Constraints
- Quality of Results (QoR)
- Timing

The reports are stored in:

```text
dc/reports/
```


### DC Results

The synthesis flow generates the synthesized design and associated output files in:

```text
dc/results/
```

The synthesized design is subsequently used as input to the IC Compiler II physical-design flow.


# Design Constraints

The design is synthesized and implemented using the timing and operating constraints defined by the project SDC and setup files.

The operating condition used for the design is:

```text
Process:      TT
Voltage:      0.85 V
Temperature:  25 °C
```

The SDC environment also specifies the required clock and I/O timing constraints.

The complete constraint files are available under:

```text
dc/source/
```


# IC Compiler II — Physical Design

The synthesized matrix multiplication accelerator is taken through physical implementation using Synopsys IC Compiler II.

The physical-design flow is divided into multiple TCL scripts.

The ICC2 files are organized under:

```text
icc2/
```

The physical-design scripts are stored under:

```text
icc2/scripts/
```

The physical-design flow includes:

1. Design initialization
2. Floorplanning
3. Power planning
4. Placement
5. Clock-tree synthesis
6. Routing
7. Filler insertion
8. Power/ground connectivity
9. Final reporting


### ICC2 Scripts

The physical implementation is divided into individual stages such as:

```text
icc2/scripts/
├── common_setup.tcl
├── floorplan.tcl
├── power_plan.tcl
├── pg_repair.tcl
├── placement.tcl
├── clock.tcl
├── route.tcl
├── fillers.tcl
├── reports.tcl
└── run_all.tcl
```

The exact scripts included in the repository correspond to the scripts used during the physical-design run.


### ICC2 Launch

From the ICC2 working directory:

```bash
icc2_shell -gui
```

The complete physical-design flow can be executed using:

```tcl
source ../scripts/run_all.tcl
```

The individual physical-design stages can also be executed separately when required.


# Physical Design Stages

## 1. Floorplanning

The synthesized design is initialized in IC Compiler II and the physical floorplan is created.

The floorplan establishes:

- Core boundary
- Standard-cell region
- I/O locations
- Placement region
- Physical design boundaries


## 2. Power Planning

Power and ground structures are created for the design.

This stage establishes the required:

- VDD connectivity
- VSS connectivity
- Power structures
- Ground structures
- Standard-cell power connections


## 3. Placement

The standard cells are placed within the core region.

Placement optimization is performed to improve:

- Timing
- Congestion
- Cell distribution
- Overall physical implementation quality


## 4. Clock Tree Synthesis

The clock network is synthesized and optimized.

Clock-tree analysis is used to inspect:

- Clock topology
- Clock latency
- Clock distribution
- Longest clock paths
- Shortest clock paths


## 5. Routing

The design undergoes global and detailed routing.

Routing establishes the physical interconnect between the placed standard cells and I/O ports.


## 6. Filler Insertion

Filler cells are inserted into the standard-cell rows to maintain physical and well continuity requirements.


## 7. PG Repair and Connectivity

Power and ground connectivity are checked after physical implementation.

Required PG connectivity and repair operations are performed as part of the ICC2 flow.


## 8. Final Reporting

Final implementation reports are generated covering relevant:

- Timing
- Area
- Power
- QoR
- Congestion
- Routing
- Clock
- Physical-design information


# Clock Tree Analysis

The clock tree was inspected using the IC Compiler II graphical interface.

The clock-tree analysis includes visual inspection of:

- Clock-tree topology
- Clock source
- Clock branches
- Clock latency
- Longest paths
- Shortest paths

The ICC2 graphical environment was used to highlight the clock tree and inspect clock latency paths.

The longest and shortest clock paths were also inspected using the ICC2 clock-tree analysis features.


# Reference Technology and Library

The project uses the SAED32 32 nm technology with the SAED32 RVT standard-cell library.

The expected reference-library organization is documented under:

```text
ref/
```

The standard-cell library used by the project is:

```text
SAED32 RVT
```

The primary operating condition is:

```text
Process:      TT
Voltage:      0.85 V
Temperature:  25 °C
```

The reference environment includes technology and library information required by Design Compiler and IC Compiler II, including:

- SAED32 RVT standard-cell libraries
- NDM technology/library data
- Liberty/DB data
- Technology files
- TLUPlus parasitic data
- Technology mapping files
- GDS technology data


# Proprietary Reference Files

The SAED32 technology libraries and technology files are proprietary and are therefore not included in this repository.

The repository documents the expected reference directory structure so that users with legitimate access to the corresponding SAED32 technology files can reproduce the flow.

Expected reference structure:

```text
ref/
│
├── lib/
│   ├── ndm/
│   │   └── saed32_rvt.ndm/
│   │
│   └── stdcell_rvt/
│       ├── saed32rvt_tt0p85v25c.db
│       └── saed32rvt_tt0p85v25c.lib
│
└── tech/
    ├── milkyway/
    │   └── saed32nm_1p9m_mw.tf
    │
    ├── star_rcxt/
    │   ├── saed32nm_1p9m_Cmax.tluplus
    │   ├── saed32nm_1p9m_Cmin.tluplus
    │   └── saed32nm_tf_itf_tluplus.map
    │
    ├── saed32nm_1p9m_gdsout_mw.map
    └── saed32nm_rvt_oa.gds
```

All directory and file paths are case-sensitive and must match the paths referenced by the project TCL scripts and setup files.


# Gate-Level Simulation Limitation

Gate-level simulation was not included for the post-synthesis and post-layout stages because the required SAED32 standard-cell functional Verilog simulation models were not available in the accessible project environment.

RTL functional correctness was verified using VCS prior to synthesis.

The synthesized and physical implementations were subsequently evaluated using Synopsys Design Compiler and IC Compiler II reports covering timing, constraints, QoR, routing, congestion, power/ground connectivity, and physical verification.


# Software Environment

| Component | Version |
|---|---|
| Operating System | Red Hat Enterprise Linux 8.7 |
| Synopsys VCS | W-2024.09-SP1 |
| Synopsys DVE | W-2024.09-SP1 |
| Synopsys Design Compiler | W-2024.09-SP1 |
| Synopsys Design Vision | W-2024.09-SP1 |
| Synopsys IC Compiler II | W-2024.09-SP1 |
| Technology | SAED32 32 nm |
| Standard-Cell Library | SAED32 RVT |
| Operating Condition | TT, 0.85 V, 25 °C |


# Repository Contents

### `vcs/`

Contains the matrix multiplication accelerator RTL and SystemVerilog testbench used for pre-synthesis functional verification.

### `dc/`

Contains the Design Compiler source files, constraints, synthesis scripts, reports, generated synthesis results, and working files.

### `icc2/`

Contains the IC Compiler II source files, physical-design TCL scripts, setup files, reports, generated results, and working files.

### `ref/`

Documents the proprietary SAED32 technology and standard-cell library structure required by the flow.

### `images/`

Contains screenshots and visual evidence from the development environment and Synopsys tools.


# Reproducibility

To reproduce this project:

1. Use a compatible RHEL environment.
2. Install/access the required Synopsys tools.
3. Obtain legitimate access to the required SAED32 technology libraries.
4. Recreate the documented `ref/` directory structure.
5. Ensure all library paths match the paths referenced in the TCL scripts and setup files.
6. Run RTL functional verification using VCS.
7. Verify the matrix multiplication simulation results.
8. Inspect the generated waveforms using DVE.
9. Run Design Compiler synthesis.
10. Review the DC reports.
11. Run the ICC2 physical-design flow.
12. Review the ICC2 reports.
13. Inspect the physical implementation.
14. Inspect the clock tree and timing paths.


# Project Evidence

Screenshots documenting the major stages of the flow are available under:

```text
images/screenshots/
```

The documentation includes evidence of:

- VCS compilation and simulation
- DVE waveform analysis
- Matrix multiplication testbench
- Design Compiler synthesis
- Design Vision
- ICC2 floorplanning
- Power planning
- Placement
- Clock-tree synthesis
- Routing
- Final physical implementation
- Clock-tree analysis


# Important Notes

- The SAED32 reference files are proprietary and are intentionally excluded.
- Paths referenced by the TCL scripts are case-sensitive.
- The RTL was functionally verified before synthesis.
- Post-synthesis and post-layout gate-level simulation was not performed because the required SAED32 functional Verilog cell models were unavailable.
- Synthesis and physical implementation were evaluated using Synopsys reports and physical-design analysis.
- The repository contains the source RTL, verification environment, synthesis scripts, physical-design scripts, reports, results, and project evidence used for the implementation.


# Author

**Sai Subrahmanya**

M.Tech — VLSI & Embedded Systems
