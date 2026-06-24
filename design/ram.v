module ram (din,rx_valid,clk,rst_n,dout,tx_valid);

    parameter MEM_DEPTH = 256; // Memory depth
    parameter ADDR_SIZE = 8 ;
    
    input  [9:0] din;      
    input  clk;            
    input  rst_n;          
    input  rx_valid;       
    output  [7:0] dout;     
    output reg tx_valid ; 

    reg [7:0] dout_temp;
    reg [ADDR_SIZE-1:0] write_addr; 
    reg [ADDR_SIZE-1:0] read_addr;  
    reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];  

    always @(posedge clk) begin
        if (!rst_n) begin
            tx_valid <= 0;
            dout_temp <= 0;
            write_addr<=0;
            read_addr<=0;
        end else if (rx_valid) begin
            case (din[9:8])
                2'b00: begin
                    write_addr <= din[7:0];
                    tx_valid <= 0;
                end
                2'b01: begin
                    mem[write_addr] <= din[7:0];
                    tx_valid <= 0;
                end
                2'b10: begin
                    read_addr <= din[7:0];
                    tx_valid <= 0;
                end
                2'b11: begin
                    dout_temp <= mem[read_addr];
                    tx_valid <= 1;
                end
            endcase
        end
    end

    assign dout = dout_temp;

endmodule
