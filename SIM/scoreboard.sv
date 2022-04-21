/*
 * Scorebaord
 */
`include "monitor.sv"
class scoreboard;

 mailbox #(transaction) mon2scb;
 transaction tr;
 virtual ahbif.monitor mif;
 logic [31:0] que[int];
 int no_tr;
 int err;

 function new (mailbox#(transaction) mon2scb);
    this.mon2scb = mon2scb;
 endfunction

 task run();
  forever begin
   mon2scb.get(tr);
   if(tr.HWRITE)begin
    memory[tr.HADDR] = tr.HWDATA;
    no_tr++;
   end
   else if(que[tr.HADDR] == tr.HWDATA)begin
    $display(" Transaction is matched");
    tr_count++;
   end
   else begin
    $display(" Transaction is not matched");
    err++;
   end
  end
 endtask

endclass : scoreboard
