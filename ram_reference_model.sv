`include "defines.svh"

class ram_reference_model;

    transaction_RAM rf_th;

    mailbox #(transaction_RAM) rf_mbx;
    mailbox #(transaction_RAM) dr_mbx;

    virtual ram_inf.REF_SB vif;

    reg [`DW-1:0] MEM [`DD-1:0];

    function new(mailbox #(transaction_RAM) dr_mbx, mailbox #(transaction_RAM) rf_mbx, virtual ram_inf.REF_SB vif);
        this.dr_mbx = dr_mbx;
        this.rf_mbx = rf_mbx;
        this.vif = vif;
    endfunction

    task start();
        for(int i=0;i<`N_t;i++)begin
            rf_th = new();
            dr_mbx.get(rf_th);
            repeat(1)@(vif.ref_cb)begin
            if(rf_th.write_enb) 
                MEM[rf_th.address] = rf_th.data_in;
                $display("REFERENCE MODEL DATA IN MEMORY MEM[%0h] = %0h", rf_th.address, MEM[rf_th.address]);
            end
            if(rf_th.read_enb)begin
                rf_th.data_out = MEM[rf_th.address];
                $display("REFERENCE MODEL DATA OUT FROM MEMORY data_out=%0h",rf_th.data_out);
            end
            rf_mbx.put(rf_th);
        end
    endtask

endclass
