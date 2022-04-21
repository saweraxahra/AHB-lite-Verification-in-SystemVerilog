/* 
 * Environment
 */
`include "driver.sv"
`include "scoreboard.sv"
class environment;
  
  bit [31:0] addr, data, addr_e;
  bit rnd;
  int n_trans; // number of transactions
  
  //generator, driver, monitor and scoreboard instance
  generator 	gen;
  driver    	drv;
  monitor   	mon;
  scoreboard	scb;
  
  //mailbox handle's
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;
  
  virtual ahbif vif; // interface

  //constructor
  function new (virtual ahbif vif);
    this.vif = vif;
       
    mon2scb  = new();
    gen2drv  = new();
    drv  = new(vif,gen2drv);
    gen  = new(gen2drv);
    mon  = new(vif,mon2scb);
    scb  = new(mon2scb);
  endfunction : new
  
  task pre();
    drv.rst();
    $display("\n------------Initializing--------------\n");
  endtask : pre
  
  task test (input addr,data,addr_e,rnd);
    fork 
      gen.genr(addr,data,addr_e,rnd);
      drv.drive;
      mon.run;
      scb.run;
    join_any
  endtask : test
  
  task wrap();
    wait(gen.n_trans == drv.no_trans);
    $display ("- Simulation Ended -");
  endtask : wrap
  
   //run task
  task envr;
    pre();
    test(addr,data,addr_e,rnd);
    wrap();
   $finish;
  endtask : envr

  `ifdef DEBUG
  `undef DEBUG
  `endif
  
endclass : environment
