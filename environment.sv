`include "defines.svh"

class environment;

virtual ram_inf.DRV drv_vif;
virtual ram_inf.MON mon_vif;
virtual ram_inf.REF_SB ref_vif;

mailbox #(transaction_RAM) gd_mbx;
mailbox #(transaction_RAM) dr_mbx;
mailbox #(transaction_RAM) rf_mbx;
mailbox #(transaction_RAM) m_mbx;

generator_RAM gen;
driver_RAM drv;
monitor mon;
ram_reference_model ref_sb;
scoreboard scb;

function new(virtual ram_inf.DRV drv_vif, virtual ram_inf.MON mon_vif, virtual ram_inf.REF_SB ref_vif);
	this.drv_vif = drv_vif;
	this.mon_vif = mon_vif;
	this.ref_vif = ref_vif;
endfunction

task build();
begin
	gd_mbx = new();
	dr_mbx = new();
	rf_mbx = new();
	m_mbx = new();

	gen = new(gd_mbx);
	drv = new(gd_mbx, dr_mbx, drv_vif);
	mon = new(mon_vif, m_mbx);
	ref_sb = new(dr_mbx, rf_mbx, ref_vif);
	scb = new(rf_mbx, m_mbx);
end
endtask

task start();
fork
	gen.start();
	drv.start();
	mon.start();
	ref_sb.start();
	scb.start();
join
	scb.compare_report();
endtask

endclass
