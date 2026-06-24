module top_TB();
    reg MOSI;
    reg SS_n;
    reg clk,rst_n;
    //reg[9:0] wr_add= 10'b 00_00000000;
    localparam [9:0] wr_data= 10'b 01_10101010;
    localparam [9:0] read_add=10'b 10_00000011;//preloaded data in memory with value 10110010
    localparam [7:0] expected_data_from_memory=8'b10110010;
    integer error_counter=0;
    wire MISO;

    integer i;

    top reggit_top(MOSI,SS_n,clk,rst_n,MISO);

    initial begin
        clk=0;
        forever begin
            #5;
            clk=~clk;
        end
    end
    
    initial begin
        $readmemb("design/mem.dat",reggit_top.reggit_ram.mem);//.reggit_ram
        rst_n=0;
        @(negedge clk);
        if(MISO!=0)begin
            $display("rst error at time %0t",$time);
            error_counter=error_counter+1;
        end
        rst_n=1;
        SS_n=0;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        MOSI=0;
            @(negedge clk);
            MOSI=0;
            @(negedge clk);
        repeat (8)begin//send _write_address
            MOSI=1;
            @(negedge clk);
        end
        SS_n=1;
        @(negedge clk);
        SS_n=0;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
        for ( i=9 ;i>=0 ;i=i-1 ) begin
            MOSI=wr_data[i];
            @(negedge clk);
        end
        SS_n=1;
        @(negedge clk);//address at 0 in mem = 8'haa
        if(reggit_top.reggit_ram.mem[255]!=8'haa)begin
            $display ("write error at time %0t",$time);
            error_counter=error_counter+1;
        end
        SS_n=0;//start new connection
        @(negedge clk);
        MOSI=1;
        @(negedge clk);//give address 10_00000011
        for ( i=9 ;i>=0 ;i=i-1 ) begin
            MOSI=read_add[i];
            @(negedge clk);
        end
        SS_n=1;
        @(negedge clk);
        SS_n=0;//start new connection
        @(negedge clk);
        MOSI=1;
        @(negedge clk);//give 11 and any dummy 8_bit data
        MOSI=1;
        @(negedge clk);
        MOSI=1;
        @(negedge clk);
        repeat (8)begin//send _8_bit_dummy data
            MOSI=$random;
            @(negedge clk);
        end
        //wait for read data from address 3 in mem
        @(negedge clk);
        @(negedge clk);
        for (i =7 ;i>=0 ;i=i-1 ) begin
            if(MISO!=expected_data_from_memory[i])begin
            $display ("read error at time %0t",$time);
            error_counter=error_counter+1;
            end
        @(negedge clk);
    end

    if(error_counter==0)begin
    $display("Congrates every thing worked as expected ");    
    end
    $stop;
    end




endmodule