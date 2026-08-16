# IC Compiler II — Physical Design

This directory contains the Synopsys IC Compiler II files used to take the synthesized Matrix Multiplication Accelerator through physical implementation.


## Directory Structure

```text
icc2/
├── README.md
├── source/
├── scripts/
├── reports/
├── results/
└── work/
```


## Physical Design Flow

The ICC2 implementation consists of:

1. Design initialization
2. Floorplanning
3. Power planning
4. Placement
5. Clock-tree synthesis
6. Routing
7. Filler insertion
8. PG connectivity and repair
9. Final reporting


## Scripts

The `scripts/` directory contains the TCL scripts used for the physical-design stages.

The flow is organized into stages such as:

```text
scripts/
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

The exact scripts in the repository correspond to the implementation flow used for this project.


## ICC2 Launch

Start IC Compiler II:

```bash
icc2_shell -gui
```

From the ICC2 working directory, the complete flow can be launched using:

```tcl
source ../scripts/run_all.tcl
```


## Floorplanning

The floorplanning stage establishes the physical design area and core boundary for the synthesized accelerator.

The floorplan is inspected using the ICC2 graphical interface.


## Power Planning

Power and ground structures are created for the design.

This stage establishes the required power/ground network and standard-cell connectivity.


## Placement

The synthesized standard cells are placed within the floorplan.

Placement optimization is performed to improve the physical implementation.


## Clock Tree Synthesis

The clock network is synthesized and optimized.

Clock-tree analysis is performed using the ICC2 graphical interface.


## Routing

Global and detailed routing are performed to establish the physical interconnect between the cells and ports.


## Filler Insertion

Filler cells are inserted after the major physical implementation stages to maintain physical continuity requirements.


## PG Repair

Power and ground connectivity is checked and repaired where necessary.


## Reports

Final physical-design reports are generated under:

```text
reports/
```

These reports provide information related to:

- Timing
- Area
- Power
- QoR
- Clock
- Congestion
- Routing
- Physical implementation


## Results

Generated ICC2 design data and physical implementation results are stored under:

```text
results/
```


## Technology

The physical implementation uses:

```text
Technology:  SAED32 32 nm
Library:     SAED32 RVT
Process:     TT
Voltage:     0.85 V
Temperature: 25 °C
```


## Notes

The SAED32 technology and standard-cell reference files are proprietary and are not included in this repository.

Users reproducing the flow must provide legitimate access to the required technology files and configure the paths referenced by the ICC2 setup scripts.
