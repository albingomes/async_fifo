`timescale 1ns / 1ps
//===================================================================================
// Project      : Asynchronous FIFO (CDC FIFO)
// File name    : testbench.sv 
// Designer     : Albin Gomes
// Device       : N/A
// Description  : testbench for async_fifo.sv 
// Limitations  : N/A
// Version      : 0.1
//===================================================================================

module testbench();

//-----------------------------------------------------------------------------------
// Nets, Regs and parameter
//-----------------------------------------------------------------------------------

parameter       TB_W_CLK_PERIOD = 100; // 10 MHz Write Clk
parameter       TB_R_CLK_PERIOD = 10;  // 100 MHz Read Clk
logic           tb_w_clk;
logic           tb_r_clk;
logic           tb_w_rst_n;
logic           tb_r_rst_n;
logic           tb_w_enable;
logic           tb_r_enable;
logic [23:0]    tb_w_data;
logic [23:0]    tb_r_data;
logic           tb_empty;
logic           tb_full;
logic           write_done;


//-----------------------------------------------------------------------------------
// DUT
//-----------------------------------------------------------------------------------
async_fifo fifo(
// Input
    .w_clk            (tb_w_clk),
    .r_clk            (tb_r_clk),
    .w_rst_n          (tb_w_rst_n),
    .r_rst_n          (tb_r_rst_n),
    .w_enable         (tb_w_enable),
    .r_enable         (tb_r_enable),
    .w_data           (tb_w_data),
// Output
    .r_data           (tb_r_data),
    .empty            (tb_empty),
    .full             (tb_full)      
);

//-----------------------------------------------------------------------------------
// Clocks 
//-----------------------------------------------------------------------------------

always #(TB_W_CLK_PERIOD/2) tb_w_clk = !tb_w_clk; // Write clk
always #(TB_R_CLK_PERIOD/2) tb_r_clk = !tb_r_clk; // Read clk

//-----------------------------------------------------------------------------------
// Initialize
//----------------------------------------------------------------------------------- 

initial begin
    tb_w_clk    <= 0;
    tb_r_clk    <= 0;
    tb_w_rst_n  <= 0;
    tb_r_rst_n  <= 0;
    tb_w_enable <= 0;
    tb_r_enable <= 0;
    tb_w_data   <= 24'h000000;
    write_done  <= 0;
end

//-----------------------------------------------------------------------------------
// Stimulus
//-----------------------------------------------------------------------------------

// FIFO write
initial begin
    #(TB_W_CLK_PERIOD*5);
    @(posedge tb_w_clk);
    tb_w_rst_n  = 1;
    @(posedge tb_w_clk);
    tb_w_enable = 1;
    for(int i=0; i<7; i++) begin
        @(posedge tb_w_clk);
        tb_w_data++;
    end
    @(posedge tb_w_clk);
    tb_w_enable = 0;
    write_done  = 1;
end

// FIFO read
initial begin
    wait(write_done == 1);
    @(posedge tb_r_clk);
    tb_r_rst_n  = 1;
    @(posedge tb_r_clk);
    tb_r_enable = 1;
end

endmodule
