import ahb3lite_pkg::*;
`include "transaction.sv"
class monitor;
  virtual ahbif.monitor mif;                 
  transaction tr;
  event all_received;
  mailbox #(transaction) mon2scb;                       

  function new(virtual ahbif.monitor mif, mailbox #(transaction) mon2scb);
    this.mif = mif;
    this.mon2scb = mon2scb;
  endfunction : new


task tr_wait; // wait for transfer
  while (!mif.HREADY || !mif.HSEL || mif.HTRANS == HTRANS_IDLE)
  begin
      @(posedge mif.HCLK);
      mif.HREADYOUT <= 1'b1;
  end
endtask : tr_wait

task ready_wait; // wait for HREADY
  while (mif.HREADY !== 1'b1 || mif.HTRANS == HTRANS_BUSY) 
  @(posedge mif.HCLK);
endtask : ready_wait

//-------------------------------------
//AHB Data task
//
task run();
forever begin
tr_wait;
ready_wait;
tr = new;
begin
	@(posedge mif.HCLK);
	tr.HADDR  <= mif.HADDR ;
	tr.HSIZE  <= mif.HSIZE;
	tr.HRESP  <= mif.HRESP;
	tr.HBURST <= mif.HBURST;
	tr.HPROT  <= mif.HPROT;
	tr.HTRANS <= mif.HTRANS;
	tr.HWDATA <= mif.HWDATA;
	tr.HREADY <= mif.HREADY;
	if(mif.HWRITE)
		begin
		@(posedge mif.HCLK)
		tr.HWDATA	<= mif.HWDATA;
		end
	mon2scb.put(tr);
        $display("Monitor recieved transaction");
	-> all_received;
end
end
endtask
endclass : monitor
