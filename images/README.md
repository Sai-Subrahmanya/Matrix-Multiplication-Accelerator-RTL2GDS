# Project Documentation and Evidence

This directory contains screenshots documenting the major stages of the Matrix Multiplication Accelerator RTL-to-GDS flow.

## Screenshot Categories

The screenshots document:

- VCS functional verification
- DVE waveform analysis
- Design Compiler synthesis
- ICC2 floorplanning
- ICC2 power planning
- ICC2 placement
- ICC2 clock-tree synthesis
- ICC2 routing
- ICC2 final physical design
- Clock-tree analysis

## Screenshot Files

The images uploaded to this repository are:

```text
images/
├── README.md
├── 01_vcs_simulation_pass.png
├── 02_dve_waveform.png
├── 03_dc_synthesis_results.png
├── 04_icc2_floorplan.png
├── 05_icc2_power_plan.png
├── 06_icc2_placement.png
├── 07_icc2_clock_tree_synthesis.png
├── 08_icc2_routing.png
├── 09_icc2_final_design.png
└── 10_clock_tree.png
```

## 01 — VCS Simulation Pass

`01_vcs_simulation_pass.png`

This screenshot provides evidence of successful RTL functional simulation using Synopsys VCS.

## 02 — DVE Waveform

`02_dve_waveform.png`

This screenshot shows the simulated RTL signals and waveform analysis using Synopsys DVE.

## 03 — Design Compiler Synthesis Results

`03_dc_synthesis_results.png`

This screenshot provides visual evidence of the Design Compiler synthesis stage and the resulting synthesized design.

## 04 — ICC2 Floorplan

`04_icc2_floorplan.png`

This screenshot shows the initial physical floorplan generated in Synopsys IC Compiler II.

## 05 — ICC2 Power Plan

`05_icc2_power_plan.png`

This screenshot shows the power-planning stage of the physical implementation flow.

## 06 — ICC2 Placement

`06_icc2_placement.png`

This screenshot shows the placement stage after standard-cell placement and optimization.

## 07 — ICC2 Clock-Tree Synthesis

`07_icc2_clock_tree_synthesis.png`

This screenshot shows the clock-tree synthesis stage and clock distribution within the design.

## 08 — ICC2 Routing

`08_icc2_routing.png`

This screenshot shows the routed physical implementation of the accelerator.

## 09 — ICC2 Final Design

`09_icc2_final_design.png`

This screenshot shows the final physical implementation after the major ICC2 implementation stages.

## 10 — Clock Tree

`10_clock_tree.png`

This screenshot provides visual evidence of the clock-tree analysis and clock distribution.

## Purpose

The screenshots provide visual evidence of the project execution and complement the RTL source, VCS verification files, Design Compiler scripts, IC Compiler II scripts, reports, and generated results.

The images are included as documentation and evidence of the RTL-to-GDS implementation flow.
