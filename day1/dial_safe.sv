`timescale 1ns/1ps

module dial_safe (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire direction,
    input wire [31:0] distance,
    output reg [6:0] position,
    output reg [31:0] part1_count,
    output reg [31:0] part2_count
);

    wire [31:0] pos32 = {25'd0, position};
    wire [31:0] d_mod = distance % 32'd100;

    wire [31:0] sum_r = pos32 + d_mod;
    wire [31:0] sum_l = pos32 + 32'd100 - d_mod;

    wire [6:0] new_pos_r = (sum_r >= 32'd100) ? (sum_r - 32'd100) : sum_r[6:0];
    wire [6:0] new_pos_l = (sum_l >= 32'd100) ? (sum_l - 32'd100) : sum_l[6:0];
    wire [6:0] new_pos = direction ? new_pos_r : new_pos_l;

    wire [31:0] z_right = (position == 7'd0) ? (distance / 32'd100) : ((distance + pos32) / 32'd100);
    wire [31:0] z_left_nz = (distance >= pos32) ? ((distance - pos32) / 32'd100 + 32'd1) : 32'd0;
    wire [31:0] z_left = (position == 7'd0) ? (distance / 32'd100) : z_left_nz;
    wire [31:0] zeros = direction ? z_right : z_left;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            position <= 7'd50;
            part1_count <= 32'd0;
            part2_count <= 32'd0;
        end else if (valid_in) begin
            position <= new_pos;
            part2_count <= part2_count + zeros;
            if (new_pos == 7'd0)
                part1_count <= part1_count + 32'd1;
        end
    end

endmodule
