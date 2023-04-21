# Intro to Processor Architecture - Project (Spring 2023)
# Y86-64 ISA Processor

## 1.Overall Goal

The goal is to develop a processor architecture design based on the Y86 ISA using Verilog. The design is thoroughly tested to satisfy all the specification requirements using simulations. The project includes the following:

- A report describing the design details of the various stages of the processor architecture, the supported features (including simulation snapshots of the features supported) and the challenges encountered.
- Verilog code for processor design and testbench

## 2.Specifications

The specifications in the processor design are as follows:

- A full fledged processor architecture implementation with 5 stage pipeline which includes support for eliminating pipeline hazards.

## 3.Design Approach
The design approach is modular, i.e., each stage is coded as separate modules and tested independently in order to help the integration without too many issues.

## 5.Design Verification

The following are the verification approaches.
- Individually tested each stage/module for its intended functionality by creating module specific test inputs.
- An automated testbench that will help to verify the design efficiently, i.e., automatically verify the state of the processor and memory after execution of each instruction in the program.
