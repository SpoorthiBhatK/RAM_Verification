`include "defines.svh"

class driver_RAM;

    transaction_RAM d_th;

    mailbox #(transaction_RAM) gd_mbx;
    mailbox #(transaction_RAM) dr_mbx;

    virtual ram_inf.DRV vif;

    covergroup drv_cg;
        WRITE : coverpoint d_th.write_enb { bins wrt[] = {0,1}; }
        READ : coverpoint d_th.read_enb { bins rd[] = {0,1}; }
        DATA_IN : coverpoint d_th.data_in { bins data = {[0:255]}; }
        ADDRESS : coverpoint d_th.address { bins address = {[0:31]}; }
     	WRXRD : cross WRITE, READ	{ignore_bins ib = binsof(WRITE.wrt[1]) && binsof(READ.rd[1]);}
    endgroup

    function new(mailbox #(transaction_RAM) gd_mbx,
                 mailbox #(transaction_RAM) dr_mbx,
                 virtual ram_inf.DRV vif);

        this.gd_mbx = gd_mbx;
        this.dr_mbx = dr_mbx;
        this.vif = vif;

        drv_cg = new();

    endfunction

    task start();

        repeat(3) @(vif.drv_cb);
        for(int i=0;i<`N_t;i++)begin
            d_th = new();
            gd_mbx.get(d_th);
            if(vif.drv_cb.reset == 0)
                repeat(1) @(vif.drv_cb) begin
                    vif.drv_cb.write_enb <= 0;
                    vif.drv_cb.read_enb <= 0;
                    vif.drv_cb.data_in <= 8'bz;
                    vif.drv_cb.address <= 0;
                    dr_mbx.put(d_th.copy());
                    repeat(1) @(vif.drv_cb);
                    $display("DRIVER DRIVING DATA TO THE INTERFACE data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", vif.drv_cb.data_in, vif.drv_cb.write_enb, vif.drv_cb.read_enb, vif.drv_cb.address, $time);
                end
            else
                repeat(1) @(vif.drv_cb) begin
                    vif.drv_cb.write_enb <= d_th.write_enb;
                    vif.drv_cb.read_enb <= d_th.read_enb;
                    vif.drv_cb.data_in <= d_th.data_in;
                    vif.drv_cb.address <= d_th.address;
                    repeat(1) @(vif.drv_cb);
                    $display("DRIVER WRITE OPERATION DRIVING DATA TO THE INTERFACE data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", vif.drv_cb.data_in, vif.drv_cb.write_enb, vif.drv_cb.read_enb, vif.drv_cb.address, $time);
                    vif.drv_cb.write_enb <= 0;
                    dr_mbx.put(d_th.copy());
                    drv_cg.sample();
                    $display("INPUT FUNCTIONAL COVERAGE = %0f", drv_cg.get_coverage());
                end
        end
    endtask
endclass
