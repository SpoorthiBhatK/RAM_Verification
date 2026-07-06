`include "defines.svh"

class scoreboard;

    transaction_RAM rf_th;
    transaction_RAM m_th;

    mailbox #(transaction_RAM) rf_mbx;
    mailbox #(transaction_RAM) m_mbx;

    logic [`DW-1:0] ref_mem [`DD-1:0];
    logic [`DW-1:0] mon_mem [`DD-1:0];

    int MATCH = 0;
    int MISMATCH = 0;

    function new(mailbox #(transaction_RAM) rf_mbx, mailbox #(transaction_RAM) m_mbx);
        this.rf_mbx = rf_mbx;
        this.m_mbx  = m_mbx;
    endfunction

    task start();
        for(int i=0;i<`N_t;i++) begin
            rf_th = new();
            m_th  = new();
            fork
                begin
                    rf_mbx.get(rf_th);
                    ref_mem[rf_th.address] = rf_th.data_out;
                    $display("############ SCOREBOARD REF data_out=%0h ADDRESS=%0h ############", ref_mem[rf_th.address], rf_th.address);
                end
                begin
                    m_mbx.get(m_th);
                    mon_mem[m_th.address] = m_th.data_out;
                    $display("!!!!!!!!!!!! SCOREBOARD MON data_out=%0h ADDRESS=%0h !!!!!!!!!!", mon_mem[m_th.address], m_th.address);
                end
            join
            if(i != (`N_t-1))
                compare_report();
        end
    endtask

    task compare_report();
        if(ref_mem[rf_th.address] === mon_mem[m_th.address])begin
            $display("REF=%0h MON=%0h", ref_mem[rf_th.address], mon_mem[m_th.address]);
            MATCH++;
            $display("DATA MATCH SUCCESSFUL MATCH=%0d",MATCH);
        end
        else begin
            $display("REF=%0h MON=%0h", ref_mem[rf_th.address], mon_mem[m_th.address]);
            MISMATCH++;
            $display("DATA MATCH FAILURE MISMATCH=%0d",MISMATCH);
        end
    endtask
endclass
