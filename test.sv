`include "defines.svh"

class test;

virtual ram_inf drv_vif;
virtual ram_inf mon_vif;
virtual ram_inf ref_vif;

environment env;

function new(virtual ram_inf drv_vif, virtual ram_inf mon_vif, virtual ram_inf ref_vif);
	this.drv_vif = drv_vif;
	this.mon_vif = mon_vif;
	this.ref_vif = ref_vif;
endfunction

task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build();
	env.start();
endtask

endclass



class test_write extends test;
transaction_RAM_write trans_write;
function new(virtual ram_inf drv_vif, virtual ram_inf mon_vif, virtual ram_inf ref_vif);
	super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build();
	begin
	trans_write = new();
	env.gen.g_th = trans_write;
	end
	env.start();
endtask
endclass

class test_read extends test;
transaction_RAM_read trans_read;
function new(virtual ram_inf drv_vif, virtual ram_inf mon_vif, virtual ram_inf ref_vif);
	super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build();
	begin
	trans_read = new();
	env.gen.g_th = trans_read;
	end
	env.start();
endtask
endclass

class test_read_write extends test;
transaction_RAM_read_write trans_read_write;
function new(virtual ram_inf drv_vif, virtual ram_inf mon_vif, virtual ram_inf ref_vif);
	super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build();
	begin
	trans_read_write = new();
	env.gen.g_th = trans_read_write;
	end
	env.start();
endtask
endclass

class test_nread_nwrite extends test;
transaction_RAM_nread_nwrite trans_nread_nwrite;
function new(virtual ram_inf drv_vif, virtual ram_inf mon_vif, virtual ram_inf ref_vif);
	super.new(drv_vif, mon_vif, ref_vif);
endfunction

task run();
	env = new(drv_vif, mon_vif, ref_vif);
	env.build();
	begin
	trans_nread_nwrite = new();
	env.gen.g_th = trans_nread_nwrite;
	end
	env.start();
endtask
endclass





class test_regression extends test;
   transaction_RAM_read  trans_read;
   transaction_RAM_write  trans_write;
   transaction_RAM_read_write trans_read_write;
   transaction_RAM_nread_nwrite trans_nread_nwrite;
function new(virtual ram_inf drv_vif, virtual ram_inf mon_vif, virtual ram_inf ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
   // $display("Read test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
///////////////////////////////////////////////////////
    begin 
    trans_read = new();
    env.gen.g_th= trans_read;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans_write = new();
    env.gen.g_th= trans_write;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans_read_write = new();
    env.gen.g_th= trans_read_write;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans_nread_nwrite = new();
    env.gen.g_th= trans_nread_nwrite;
    end
    env.start;
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
  endtask
endclass
