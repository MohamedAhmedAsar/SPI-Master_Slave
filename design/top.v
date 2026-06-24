module top(MOSI,SS_n,clk,rst_n,MISO);

    input MOSI;
    input SS_n;
    input clk,rst_n;

    wire tx_valid;
    wire [7:0] tx_data;
    wire rx_valid;
    wire [9:0] rx_data; 

    output MISO;
    

    slave reggit_slave(MOSI,MISO,SS_n,clk,rst_n,tx_data,tx_valid,rx_valid,rx_data);
    ram reggit_ram(rx_data,rx_valid,clk,rst_n,tx_data,tx_valid);

endmodule