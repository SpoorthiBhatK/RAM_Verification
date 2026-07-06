`include "defines.svh"

class monitor;
    transaction_RAM m_th;
    mailbox #(transaction_RAM) m_mbx;
    virtual ram_inf.MON vif;
    covergroup mon_cg;
        DATA_OUT : coverpoint m_th.data_out
        {
            bins dout= {[0:255]};
        }
    endgroup

    function new(virtual ram_inf.MON vif, mailbox #(transaction_RAM) m_mbx);
        this.vif = vif;
        this.m_mbx = m_mbx;
        mon_cg = new();
    endfunction

    task start();
        repeat(4) @(vif.mon_cb);
        for(int i=0;i<`N_t;i++)begin
            	m_th = new();
		repeat(1) @(vif.mon_cb)begin
 			m_th.data_out = vif.mon_cb.data_out;
			m_th.address  = vif.mon_cb.address;
 		end
 		$display("MONITOR PASSING THE DATA TO SCOREBOARD data_out=%0h", m_th.data_out, $time);
		 m_mbx.put(m_th);
		 mon_cg.sample();
 		$display("OUTPUT FUNCTIONAL COVERAGE = %0d", mon_cg.get_coverage());
	 repeat(1) @(vif.mon_cb);
	 end
   endtask
endclass

            
