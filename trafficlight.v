module traffic_light_controller(
    input clk,             // Clock signal (1 Hz)
    input reset,           // Reset signal
    output reg [2:0] north, // 3-bit signal for north direction (R,Y,G)
    output reg [2:0] east,  // 3-bit signal for east direction (R,Y,G)
    output reg [2:0] south, // 3-bit signal for south direction (R,Y,G)
    output reg [2:0] west,  // 3-bit signal for west direction (R,Y,G)
    output reg [6:0] seg,   // 7-segment display for countdown (common cathode)
    output reg [3:0] an     // Anodes for selecting the digit (2 digits)
);

// State encoding for the traffic lights
parameter RED    = 3'b100;
parameter YELLOW = 3'b010;
parameter GREEN  = 3'b001;

reg [5:0] countdown;       // 6-bit countdown timer (for numbers 0 to 59)
reg [1:0] state;           // State to track which direction is green
reg [3:0] tens;            // Tens digit for countdown
reg [3:0] ones;            // Ones digit for countdown
reg [16:0] mux_counter;    // Multiplexing counter for 7-segment display
reg current_digit;         // 0: tens place, 1: ones place

// Clock divider: for slower multiplexing of the 7-segment display
always @(posedge clk or posedge reset) begin
    if (reset) begin
        mux_counter <= 0;
    end else begin
        mux_counter <= mux_counter + 1;
    end
end

// Traffic Light State Machine and Countdown
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;           // Start with north light being green
        countdown <= 30;      // Start with 30 seconds countdown
    end else begin
        // Countdown logic
        if (countdown == 0) begin
            // Reset countdown when it reaches 0 and change state
            countdown <= 30;
            state <= state + 1;  // Move to next direction
        end else begin
            countdown <= countdown - 1;
        end
    end
end

// Extract tens and ones digits from countdown
always @(countdown) begin
    tens = countdown / 10;
    ones = countdown % 10;
end

// Traffic light controller based on the current state
always @(state or countdown) begin
    // Default: all lights red
    north = RED;
    east  = RED;
    south = RED;
    west  = RED;

    case (state)
        2'b00: begin  // North is green, then yellow
            if (countdown > 5)
                north = GREEN;
            else
                north = YELLOW;
        end
        2'b01: begin  // East is green, then yellow
            if (countdown > 5)
                east = GREEN;
            else
                east = YELLOW;
        end
        2'b10: begin  // South is green, then yellow
            if (countdown > 5)
                south = GREEN;
            else
                south = YELLOW;
        end
        2'b11: begin  // West is green, then yellow
            if (countdown > 5)
                west = GREEN;
            else
                west = YELLOW;
        end
    endcase
end

// Multiplexing logic for two 7-segment displays (tens and ones)
always @(posedge mux_counter[16] or posedge reset) begin
    if (reset) begin
        current_digit <= 0;
    end else begin
        current_digit <= ~current_digit;  // Toggle between tens and ones
    end
end

// Control anodes for selecting which digit is active
always @(*) begin
    case (current_digit)
        0: an = 4'b1110;  // Activate tens digit (anode 0)
        1: an = 4'b1101;  // Activate ones digit (anode 1)
        default: an = 4'b1111;  // Turn off all displays by default
    endcase
end

// 7-segment display decoder
always @(*) begin
    case (current_digit)
        0: begin
            // Display tens digit
            case (tens)
                4'd0: seg = 7'b1000000; // 0
                4'd1: seg = 7'b1111001; // 1
                4'd2: seg = 7'b0100100; // 2
                4'd3: seg = 7'b0110000; // 3
                4'd4: seg = 7'b0011001; // 4
                4'd5: seg = 7'b0010010; // 5
                4'd6: seg = 7'b0000010; // 6
                4'd7: seg = 7'b1111000; // 7
                4'd8: seg = 7'b0000000; // 8
                4'd9: seg = 7'b0010000; // 9
                default: seg = 7'b1111111; // Blank
            endcase
        end
        1: begin
            // Display ones digit
            case (ones)
                4'd0: seg = 7'b1000000; // 0
                4'd1: seg = 7'b1111001; // 1
                4'd2: seg = 7'b0100100; // 2
                4'd3: seg = 7'b0110000; // 3
                4'd4: seg = 7'b0011001; // 4
                4'd5: seg = 7'b0010010; // 5
                4'd6: seg = 7'b0000010; // 6
                4'd7: seg = 7'b1111000; // 7
                4'd8: seg = 7'b0000000; // 8
                4'd9: seg = 7'b0010000; // 9
                default: seg = 7'b1111111; // Blank
            endcase
        end
    endcase
end

endmodule