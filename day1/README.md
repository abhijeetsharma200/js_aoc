# Day 1: Dial Safe

Solution for Advent of Code 2025 Day 1 implemented in synthesizable SystemVerilog.

## Problem Summary

A safe has a circular dial numbered 0-99. The dial starts at position 50. Given a sequence of rotations (L for left/decreasing, R for right/increasing) with distances, we need to:

- **Part 1**: Count how many times the dial ends at position 0 after a rotation
- **Part 2**: Count every time the dial passes through or lands on 0 during any rotation

## Solution Approach

The `dial_safe` module processes one rotation per clock cycle when `valid_in` is asserted.

### Position Calculation

Since the dial is circular (0-99), the new position after a rotation is computed using modular arithmetic:
- Right rotation: `(position + distance) % 100`
- Left rotation: `(position + 100 - (distance % 100)) % 100`

### Zero Crossing Count (Part 2)

The key insight is that we don't need to simulate each click. Instead, we calculate how many times zero is crossed mathematically:

- **Right rotation**: Zero is crossed each time we wrap from 99 to 0. This happens `(position + distance) / 100` times (with special handling when starting at 0).
- **Left rotation**: Zero is crossed when we decrement past 0 to 99. If the distance exceeds the current position, we cross zero at least once, plus additional times for each full rotation.

### Hardware Design

The design is fully combinational for the position and zero-crossing calculations, with registered outputs updated on each valid input. This allows for straightforward pipelining if needed and keeps the critical path short.

## Files

- `dial_safe.sv` - Main RTL module
- `tb.sv` - Testbench that reads input from file and displays results
- `a.txt` - Place your puzzle input here (not included)

## Running the Simulation

Place your puzzle input in `a.txt` in the same directory. The input format is one rotation per line, e.g.:
```
L68
R48
L5
```

Then run with any Verilog simulator. For example with Icarus Verilog:

```bash
iverilog -g2012 -o sim dial_safe.sv tb.sv
vvp sim
```

Or with Verilator:

```bash
verilator --binary --timing -j 0 tb.sv dial_safe.sv
./obj_dir/Vtb
```

The simulation will output the results for both parts.

## Results

- Part 1: 984
- Part 2: 5657
