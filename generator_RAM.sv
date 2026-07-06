`include "defines.svh"

class generator_RAM;
    transaction_RAM g_th;
    mailbox #(transaction_RAM) gd_mbx;
    function new(mailbox #(transaction_RAM) gd_mbx);
        this.gd_mbx = gd_mbx;
        g_th = new();
    endfunction
    task start();
        for(int i=0;i<`N_t;i++)
        begin
            assert(g_th.randomize());
            gd_mbx.put(g_th.copy());
            $display("GENERATOR : data_in=%0h write=%0d read=%0d address=%0h time=%0t", g_th.data_in, g_th.write_enb, g_th.read_enb, g_th.address, $time);
        end
    endtask

endclass
