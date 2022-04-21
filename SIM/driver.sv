import ahb3lite_pkg::*;
`include "generator.sv"
class driver;
  virtual ahbif.master dif; // interface
  mailbox #(transaction) gen2drv; // mailbox
  int no_trans; // number of transactions

  function new(virtual ahbif.master dif,mailbox gen2drv);
     begin
       this.dif     = dif;
       this.gen2drv = gen2drv;
     end
  endfunction 
  
  task rst; // reset
    wait(!dif.HRESET) // active low state
      begin
      $display("HRESETn is in high state");
      dif.HADDR  <= 0; 
      dif.HSIZE  <= 0;                   
      dif.HREADY <= 1;
      end
    wait(dif.HRESET)
      $display("HRESETn is in low state");
  endtask : rst
 
  task read_send; // read operation
    begin 
        transaction tr; 
	gen2drv.get(tr);
	@(posedge dif.HCLK);
        dif.HREADY  <= 1'b1;
        dif.HADDR   <= tr.HADDR;
        dif.HWRITE  <= 1'b0;
        @(posedge dif.HCLK)
        dif.HWRITE  <= tr.HWRITE;
        @(posedge dif.HCLK);
        tr.HRDATA   = dif.HWDATA;
        $display("\t THe data [HWDATA] = %0h \t is read from address [HADDR] = %0h",tr.HRDATA,tr.HADDR);
	@(posedge dif.HCLK);
        end
  endtask

  task write_send; // write operation
    begin
        transaction tr;
        gen2drv.get(tr);
        @(posedge dif.HCLK);
        dif.HREADY  <= 1'b1;
        dif.HADDR   <= tr.HADDR;
        dif.HWRITE  <= 1'b1;
        @(posedge dif.HCLK);
        dif.HWRITE  <= tr.HWRITE;
        dif.HWDATA  <= tr.HWDATA;
        $display("\t THe data [HWDATA] = %0h \t is written on address [HADDR] = %0h",tr.HWDATA,tr.HADDR);
        @(posedge dif.HCLK);
      end
  endtask

  task send; // main task to run
    forever begin 
        $display("Driver has recieved transfer : %0d ",no_trans);
        if (tr.HWRITE == 1'b0) begin
        read_send;
	$display("          Read transaction             ");
        end
        if (tr.HWRITE == 1'b1) begin
        write_send;
        $display("          Write transaction            ");
	end
        dif.HRESP = HRESP_OKAY;
        dif.HREADY = 1'b1; // consider is hreadyout
     end
     $display("------------------------------------------");
     no_trans++; // next transaction   
  endtask : send
  
  task drive;
    fork
      begin
        wait(!dif.HRESET); //Wait for reset
      end
      begin
        forever
          send(); // main driver task
        end
    join_any
    disable fork;
  endtask : drive
endclass: driver
