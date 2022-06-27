`timescale 1ns / 1ps
//===================================================================================
// Project      : Asynchronous FIFO (CDC FIFO)
// File name    : async_fifo.sv 
// Designer     : Albin Gomes
// Device       : N/A
// Description  : Asynchronous FIFO for data crossing over clock domains
// Limitations  : N/A
// Version      : 0.1
//===================================================================================

module async_fifo(
// Input
    input               w_clk,
    input               r_clk,
    input               w_rst_n,
    input               r_rst_n,
    input               w_enable,
    input               r_enable,
    input        [23:0] w_data,
// Output
    output logic [23:0] r_data,
    output              empty,
    output              full        
);
    
//-----------------------------------------------------------------------------------
// Nets, Regs and states
//-----------------------------------------------------------------------------------  
   
logic [0:7][23:0]   fifo_mem; // 8 words, 24 bits each
logic [3:0]         w_pointer;
logic [2:0]         w_addr;
logic [3:0]         r_pointer;
logic [2:0]         r_addr;
logic [3:0]         r_pointer1_sync, r_pointer2_sync;
logic [3:0]         w_pointer1_sync, w_pointer2_sync;
 
//-----------------------------------------------------------------------------------
// Instantiations
//-----------------------------------------------------------------------------------
    
// write module instantiation
w_pointer write_module(
// Input
    .w_clk           (w_clk),
    .w_rst_n         (w_rst_n),
    .w_enable        (w_enable),
    .r_ptr_synced    (r_pointer2_sync), 
// Output
    .w_pointer       (w_pointer),
    .w_addr          (w_addr),
    .full            (full)
); 
    
// read module instantiation
r_pointer read_module(
// Input
    .r_clk           (r_clk),
    .r_rst_n         (r_rst_n),
    .r_enable        (r_enable),
    .w_ptr_synced    (w_pointer2_sync), 
// Output
    .r_pointer       (r_pointer),
    .r_addr          (r_addr),
    .empty           (empty)
);

//-----------------------------------------------------------------------------------
// Processes
//-----------------------------------------------------------------------------------
    
// Read pointer synced to write clock domain    
always_ff @ (posedge w_clk) begin    
    if (w_rst_n == 0) begin
        r_pointer1_sync <= 0;
        r_pointer2_sync <= 0;
    end
    else begin
        r_pointer1_sync <= r_pointer;
        r_pointer2_sync <= r_pointer1_sync;
    end
end

// Write pointer synced to read clock domain    
always_ff @ (posedge r_clk) begin    
    if (r_rst_n == 0) begin
        w_pointer1_sync <= 0;
        w_pointer2_sync <= 0;
    end
    else begin
        w_pointer1_sync <= w_pointer;
        w_pointer2_sync <= w_pointer1_sync;
    end
end

// FIFO write
always_ff @ (posedge w_clk) begin
    if(w_rst_n == 0) begin
        fifo_mem[0:7]  <= 0;
    end 
    else begin
        if (w_enable == 1 && full != 1) begin
            fifo_mem[w_addr]  <= w_data;
        end
    end
end
    
// FIFO read
always_ff @ (posedge r_clk) begin
    if(r_rst_n == 0) begin
        r_data  <= 0;
    end 
    else begin
        if (r_enable == 1 && empty != 1) begin
            r_data  <= fifo_mem[r_addr];
        end
    end
end

    
endmodule
