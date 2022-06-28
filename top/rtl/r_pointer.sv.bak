`timescale 1ns / 1ps
//===================================================================================
// Project      : Asynchronous FIFO (CDC FIFO)
// File name    : r_pointer.sv 
// Designer     : Albin Gomes
// Device       : N/A
// Description  : module generates read addr in binary and read pointer in grey code
//                also generates the empty flag
// Limitations  : N/A
// Version      : 0.1
//===================================================================================

module r_pointer(
// Input
    input               r_clk,
    input               r_rst_n,
    input               r_enable,
    input        [3:0]  w_ptr_synced, // this is the write pointer in grey code synced to read domain
// Output
    output logic [3:0]  r_pointer,    // grey code
    output       [2:0]  r_addr,       // binary   
    output logic        empty
);
    
//-----------------------------------------------------------------------------------
// Nets, Regs and states
//-----------------------------------------------------------------------------------

logic [3:0] read_binary;
logic [3:0] read_grey;
logic       read_empty; 

//-----------------------------------------------------------------------------------
// Assignments
//-----------------------------------------------------------------------------------

assign read_grey  = read_binary>>1 ^ read_binary;
assign read_empty = (read_grey == w_ptr_synced); 
assign r_addr     = read_binary[2:0];

//-----------------------------------------------------------------------------------
// Processs
//-----------------------------------------------------------------------------------   
    
// read_binary increment
always_ff @ (posedge r_clk) begin
    if (r_rst_n == 0) begin
        read_binary    <= 0;
    end 
    else begin
        if(r_enable && !read_empty) begin
           read_binary <= (read_binary == 15)? 0:read_binary + 1; 
        end
    end
end 
    
// r_pointer update
always_ff @ (posedge r_clk) begin
    if (r_rst_n == 0) begin
        r_pointer  <= 0;
    end
    else begin
        r_pointer  <= read_grey;
    end 
end

// empty condition
always_ff @ (posedge r_clk) begin
    if (r_rst_n == 0) begin
        empty    <= 0;
    end
    else begin
        empty    <= read_empty;
    end
end

    
    
    
endmodule
