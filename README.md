# Traffic Light Control System 🚦

## Overview
The **Traffic Light Control System** is a Verilog-based digital system designed to regulate and optimize traffic flow by managing the sequence and timing of traffic lights (Red, Yellow, Green) at an intersection. It ensures:
- Smooth traffic flow
- Collision avoidance
- Pedestrian safety

This project leverages a **Finite State Machine (FSM)** and is implemented on an FPGA platform.

---

## Features
1. **Efficient Traffic Management:** Optimized light sequences based on timers.
2. **Collision Avoidance:** Logical signal control to reduce accidents.
3. **Real-Time Performance:** FPGA deployment for accurate synchronization.
4. **Pedestrian Safety:** Supports dedicated crossing signals.

---

## System Requirements
### Hardware
- **FPGA Board:** Xilinx Basys 3 or equivalent.
- **LEDs and 7-Segment Displays:** For traffic lights and countdown.
- **Power Supply and Connectors**
  
### Software
- **Xilinx Vivado:** Design, simulate, and synthesize Verilog code.
- **Supported Verilog Standard:** IEEE-1364.

---

## Working Principle

### Inputs:
1. **Clock (CLK):** Synchronizes system operations.
2. **Reset (RESET):** Initializes states and timers.

### Outputs:
1. **Traffic Signals:** Red, Yellow, Green LEDs for four directions (North, East, South, West).
2. **Countdown Timer:** Displays remaining active signal time on a 2-digit **7-segment display**.

### State Transitions:
The system cycles through the following states:
1. **Green:** 25 seconds for active direction.
2. **Yellow:** 5 seconds for active direction.
3. **Red:** Managed based on other active states.

FSM State Diagram:
![FSM State Diagram Animation](https://placeholder-url.com/fsm-animation.gif)

---

## Implementation

### Design
The **Finite State Machine (FSM)** is implemented with three states:
- **Green State:** Current active direction receives Green signal.
- **Yellow State:** Transition signal before Red.
- **Red State:** Ensures other directions remain safe.

### Circuit Components:
1. **Registers:** Store state and timing data.
2. **Adders/Subtractors:** Increment and decrement countdowns.
3. **Multiplexers:** Control signal flow.
4. **Comparators:** Evaluate timing thresholds for transitions.

System Design Overview:
![Circuit Diagram Animation](https://placeholder-url.com/circuit-animation.gif)

### Code Example:
Here’s a snippet of the Verilog code managing the FSM:
```verilog
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;  // Reset to initial state (North Green)
        countdown <= 30;
    end else begin
        if (countdown == 0) begin
            state <= state + 1; // Move to the next state
            countdown <= 30;    // Reset timer
        end else begin
            countdown <= countdown - 1; // Decrement timer
        end
    end
end
