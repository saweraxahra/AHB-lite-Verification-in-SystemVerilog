`include "generator.sv"
class driver;
  virtual memory inf_d;
  
  mailbox gen2drv;

  function new(virtual memory inf_d,mailbox gen2drv);
     begin
       this.inf_d = inf_d;
       this.gen2drv = gen2drv;
     end
  endfunction 
  
  task rst; // reset
    wait(!inf_d.HRESET) // active low state
      begin
      $display("Reset state is low");
      inf_d.HADDR <= 0; 
      inf_d.HSIZE <= 0;                   
      inf_d.HREADY <= 0;
      end
    wait(inf_d.HRESET)
      $display("Reset state is high");
  endtask
 
  task read_send; // read operation
    while (inf_d.HRESET)
      forever begin
        @(posedge inf_d.HCLK);
        inf_d.HREADY <= 1;
        inf_d.HWRITE <= 0;
        inf_d.HADDR <= tr.HADRR;
        @(posedge inf_d.HCLK);
        inf_d.HRDATA <= tr.HWDATA;
      end
  endtask

  task write_send; // write operation
    while (inf_d.HRESET)
      forever begin
        @(posedge inf_d.HCLK);
        inf_d.HREADY <= 1;
        inf_d.HWRITE <= 1;
        inf_d.HADDR <= tr.HADRR;
        @(posedge inf_d.HCLK);
        inf_d.HWDATA <= tr.HWDATA;
      end
  endtask

    task run; // main task to run
      transaction tr;
      gen2drv.get(tr);
      @(posedge inf_d.HCLK);
      if (tr.HWRITE == 1);
      write_send;
      $display("Write transaction");
      elseif (tr.HWRITE == 0);
      read_send;
      $display("Read transaction");
      
    endtask
endclass: driver
