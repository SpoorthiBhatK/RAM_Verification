`include "defines.svh"

interface ram_inf(input bit clk, reset);
    logic [`DW-1:0] data_in;
    logic write_enb;
    logic read_enb;
    logic [`AW-1:0] address;
    logic [`DW-1:0] data_out;

    clocking drv_cb @(posedge clk);
        default input #0 output #0;
        output write_enb;
        output read_enb;
        output data_in;
        output address;
        input reset;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #0 output #0;
        input data_out;
	input address;
	input reset;
    endclocking

    clocking ref_cb @(posedge clk);
        default input #0 output #0;
      //  input write_enb;
      //  input read_enb;
      //  input data_in;
      //  input address;
    endclocking

    modport DRV    (clocking drv_cb);
    modport MON    (clocking mon_cb);
    modport REF_SB (clocking ref_cb);

endinterface
