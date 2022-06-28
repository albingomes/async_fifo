`timescale 1ns / 1ps
//===================================================================================
// Project      : Asynchronous FIFO (CDC FIFO)
// File name    : w_pointer.sv 
// Designer     : Albin Gomes
// Device       : N/A
// Description  : module generates write addr in binary and write pointer in grey code
//                also generates the full flag
// Limitations  : N/A
// Version      : 0.1
//===================================================================================

module w_pointer(
// Input
    input               w_clk,
    input               w_rst_n,
    input               w_enable,
    input        [3:0]  r_ptr_synced, // this is the read pointer in grey code synced to write domain
// Output
    output logic [3:0]  w_pointer,    // grey code
    output       [2:0]  w_addr,       // binary   
    output logic        full
    );


//-----------------------------------------------------------------------------------
// Nets, Regs and states
//-----------------------------------------------------------------------------------

logic [3:0] write_binary;
logic [3:0] write_grey;
logic       write_full;

//-----------------------------------------------------------------------------------
// Assignment
//-----------------------------------------------------------------------------------

assign write_full   = (write_grey[3] != r_ptr_synced[3]) && (write_grey[2] != r_ptr_synced[2]) && (write_grey[1:0] != r_ptr_synced[1:0]);
assign w_addr       = write_binary[2:0];
assign write_grey   = write_binary>>1 ^ write_binary;

//-----------------------------------------------------------------------------------
// Processes
//-----------------------------------------------------------------------------------

// write_binary increment
always_ff @ (posedge w_clk) begin
    if (w_rst_n == 0) begin
        write_binary    <= 0;
    end 
    else begin
        if(w_enable && !write_full) begin
           write_binary <= (write_binary == 15)? 0:write_binary + 1; 
        end
    end
end

// w_pointer update
always_ff @ (posedge w_clk) begin
    if (w_rst_n == 0) begin
        w_pointer  <= 0;
    end
    else begin
        w_pointer  <= write_grey;
    end 
end

// full condition
always_ff @ (posedge w_clk) begin
    if (w_rst_n == 0) begin
        full    <= 0;
    end
    else begin
        full    <= write_full;
    end
end


endmodule
  
