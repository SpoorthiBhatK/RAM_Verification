`include "defines.svh"

class transaction_RAM;
    rand logic [`DW-1:0] data_in;
    rand logic write_enb;
    rand logic read_enb;
    rand logic [`AW-1:0] address;

    bit [`DW-1:0] data_out;

    constraint rd_wt
    {
        {write_enb, read_enb} inside {[0:2]};
    }

    virtual function transaction_RAM copy();
        copy = new();
        copy.data_in   = this.data_in;
        copy.write_enb = this.write_enb;
        copy.read_enb  = this.read_enb;
        copy.address   = this.address;
        return copy;
    endfunction

endclass

class transaction_RAM_write extends transaction_RAM;
constraint rd_wt{{write_enb, read_enb} == 2'b10;}
virtual function transaction_RAM copy();
	transaction_RAM_write copy1;
        copy1 = new();
        copy1.data_in   = this.data_in;
        copy1.write_enb = this.write_enb;
        copy1.read_enb  = this.read_enb;
        copy1.address   = this.address;
        return copy1;
    endfunction
endclass

class transaction_RAM_read extends transaction_RAM;
constraint rd_wt{{write_enb, read_enb} == 2'b01;}
virtual function transaction_RAM copy();
	transaction_RAM_read copy2;
        copy2 = new();
        copy2.data_in   = this.data_in;
        copy2.write_enb = this.write_enb;
        copy2.read_enb  = this.read_enb;
        copy2.address   = this.address;
        return copy2;
    endfunction
endclass

class transaction_RAM_read_write extends transaction_RAM;
constraint rd_wt{{write_enb, read_enb} == 2'b11;}
virtual function transaction_RAM copy();
	transaction_RAM_read_write copy3;
        copy3 = new();
        copy3.data_in   = this.data_in;
        copy3.write_enb = this.write_enb;
        copy3.read_enb  = this.read_enb;
        copy3.address   = this.address;
        return copy3;
    endfunction
endclass

class transaction_RAM_nread_nwrite extends transaction_RAM;
constraint rd_wt{{write_enb, read_enb} == 2'b00;}
virtual function transaction_RAM copy();
	transaction_RAM_nread_nwrite copy4;
        copy4 = new();
        copy4.data_in   = this.data_in;
        copy4.write_enb = this.write_enb;
        copy4.read_enb  = this.read_enb;
        copy4.address   = this.address;
        return copy4;
    endfunction
endclass

