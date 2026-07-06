`include "ram_package.sv"
`include "RAM.sv"

module top();

import ram_package::*;

logic clk;
logic reset;

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    @(posedge clk);
    reset = 0;
    repeat(1) @(posedge clk);
    reset = 1;
    repeat(1) @(posedge clk);
    reset = 0;
    repeat(1) @(posedge clk);
    reset = 1;
end

ram_inf intrf(clk, reset);

RAM DUV(
    .clk(clk),
    .reset(reset),
    .write_enb(intrf.write_enb),
    .read_enb(intrf.read_enb),
    .address(intrf.address),
    .data_in(intrf.data_in),
    .data_out(intrf.data_out)
);

test t = new(intrf.DRV, intrf.MON, intrf.REF_SB);
test_write tw = new(intrf.DRV, intrf.MON, intrf.REF_SB);
test_read tr = new(intrf.DRV, intrf.MON, intrf.REF_SB);
test_read_write trw = new(intrf.DRV, intrf.MON, intrf.REF_SB);
test_nread_nwrite tnrw = new(intrf.DRV, intrf.MON, intrf.REF_SB);
test_regression trg = new(intrf.DRV, intrf.MON, intrf.REF_SB);
initial begin
    t.run();
    tw.run();
    tr.run();
    trw.run();
    tnrw.run();
    trg.run();
    $finish;
end

endmodule
