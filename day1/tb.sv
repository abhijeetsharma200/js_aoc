`timescale 1ns/1ps

module tb;
    reg clk = 0;
    reg rst_n = 0;
    reg valid_in = 0;
    reg direction = 0;
    reg [31:0] distance = 0;
    wire [6:0] position;
    wire [31:0] part1_count;
    wire [31:0] part2_count;

    dial_safe dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .direction(direction),
        .distance(distance),
        .position(position),
        .part1_count(part1_count),
        .part2_count(part2_count)
    );

    always #5 clk = ~clk;

    integer fd;
    integer scan_result;
    reg [7:0] dir_char;
    integer dist_val;
    integer line_count;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Reset
        rst_n = 0;
        #30;
        rst_n = 1;
        @(posedge clk);
        @(posedge clk);

        $display("Initial position: %d", position);

        // Open input file - put your puzzle input in this file
        fd = $fopen("a.txt", "r");
        if (fd == 0) begin
            $display("ERROR: Cannot open a.txt");
            $finish;
        end

        line_count = 0;

        // Process each line
        while (!$feof(fd)) begin
            scan_result = $fscanf(fd, "%c%d\n", dir_char, dist_val);
            if (scan_result == 2) begin
                line_count = line_count + 1;

                // Set inputs
                direction = (dir_char == "R");
                distance = dist_val;

                // Pulse valid_in for one clock cycle
                @(posedge clk);
                valid_in = 1;
                @(posedge clk);
                valid_in = 0;
            end
        end

        $fclose(fd);

        // Wait for final processing
        @(posedge clk);
        @(posedge clk);

        $display("");
        $display("========== RESULTS ==========");
        $display("Processed %0d lines", line_count);
        $display("Part 1: %0d", part1_count);
        $display("Part 2: %0d", part2_count);

        $finish;
    end

endmodule
