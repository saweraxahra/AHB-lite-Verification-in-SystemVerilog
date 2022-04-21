/* 
 * Generator class
 */

import ahb3lite_pkg::*;
`include "transaction.sv"
class generator;
  rand transaction tr;
  mailbox #(transaction) gen2drv;
  int no_trans; // number of transactions
  bit [31:0] addr,data,addr_e;
  bit rnd;

  function new (mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
    // trans = new();
  endfunction : new
  
  task single_rd(input addr, rnd);
  // bit [2:0] trans_size;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_SINGLE;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();	
    gen2drv.put(tr);
    $display("-------SINGLE BURST read-----------\n");
  endtask : single_rd
  
  task single_wt(input addr, data, rnd);
  // bit [2:0] trans_size;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_SINGLE;
    this.tr.HTRANS = HTRANS_NONSEQ;
    char = tr.randomize();	
    gen2drv.put(tr);
    $display("-------SINGLE BURST Write -----------\n");
  endtask : single_wt
  
  task incr4_rd(input addr, rnd);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_INCR4;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(3)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HADDR = addr;	
       	this.tr.HWRITE = '0; 			
       	this.tr.HBURST = HBURST_INCR4;
	this.tr.HTRANS = HTRANS_SEQ;
       	this.tr.HSIZE = addr_sz; 
       	char = tr.randomize();
	addr = addr+tr_size;
	this.tr.HADDR = addr;
	gen2drv.put(tr);
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------INCR4 BURST read-----------\n");
  endtask : incr4_rd
  
  task incr4_wt(input addr, data, rnd);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_INCR4;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(3)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HADDR = addr;	
       	this.tr.HWRITE = '1; 			
       	this.tr.HBURST = HBURST_INCR4;
	this.tr.HTRANS = HTRANS_SEQ;
       	this.tr.HSIZE = addr_sz; 
       	char = tr.randomize();
	addr = addr+tr_size;
	this.tr.HADDR = addr;
	gen2drv.put(tr);
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------INCR4 BURST write-----------\n");
  endtask : incr4_wt
  
  task incr8_rd(input addr,rnd);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_INCR8;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(7)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HADDR = addr;	
       	this.tr.HWRITE = '0; 			
       	this.tr.HBURST = HBURST_INCR8;
	this.tr.HTRANS = HTRANS_SEQ;
       	this.tr.HSIZE = addr; 
       	char = tr.randomize();
	addr = addr+tr_size;
	this.tr.HADDR = addr;
	gen2drv.put(tr);
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------INCR8 BURST read-----------\n");
  endtask : incr8_rd
  
  task incr8_wt(input addr, data, rnd);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_INCR8;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(7)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HADDR = addr;	
       	this.tr.HWRITE = '1; 			
       	this.tr.HBURST = HBURST_INCR8;
	this.tr.HTRANS = HTRANS_SEQ;
       	this.tr.HSIZE = addr_sz; 
       	char = tr.randomize();
	addr = addr+tr_size;
	this.tr.HADDR = addr;
	gen2drv.put(tr);
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------INCR8 BURST write-----------\n");
  endtask : incr8_wt
  
  task incr16_rd(input addr, rnd);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_INCR16;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(15)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HADDR = addr;	
       	this.tr.HWRITE = '0; 			
       	this.tr.HBURST = HBURST_INCR16;
	this.tr.HTRANS = HTRANS_SEQ;
       	this.tr.HSIZE = addr; 
       	char = tr.randomize();
	addr = addr+tr_size;
	this.tr.HADDR = addr;
	gen2drv.put(tr);
	
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------INCR16 BURST read-----------\n");
  endtask : incr16_rd
  
  task incr16_wt(input addr, data, rnd);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_INCR16;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(15)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HADDR = addr;	
       	this.tr.HWRITE = '1; 			
       	this.tr.HBURST = HBURST_INCR16;
	this.tr.HTRANS = HTRANS_SEQ;
       	this.tr.HSIZE = addr_sz; 
       	char = tr.randomize();
	addr = addr+tr_size;
	this.tr.HADDR = addr;
	gen2drv.put(tr);
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------INCR16 BURST write-----------\n");
  endtask : incr16_wt
  
  task wrap4_rd(input addr, addr_e);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_WRAP4;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(3)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HWRITE = '0; 			
       	this.tr.HBURST = HBURST_WRAP4;
       	this.tr.HSIZE = HSIZE_WORD; 
       	this.tr.HTRANS = HTRANS_SEQ;
	gen2drv.put(tr);
	case(tr.HSIZE)
           0 : tr_size = 1;
           1 : tr_size = 2;
	   2 : tr_size = 4;
        endcase 
        gen2drv.put(tr);
        addr = addr+tr_size ;
	if(addr >= addr_e)
	begin
	addr = addr_e - (tr_size*3);
	end
        this.tr.HADDR = addr;
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------WRAP4 BURST read-----------\n");
  endtask : wrap4_rd
  
  task wrap4_wt(input addr, data, addr_e);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_WRAP4;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(3)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);	
       	this.tr.HWRITE = '1; 			
       	this.tr.HBURST = HBURST_WRAP4;
       	this.tr.HTRANS = HTRANS_SEQ; 
         case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
         endcase 
        gen2drv.put(tr);
       	addr = addr+tr_size ;
	if(addr >= addr_e)
	begin
	addr = addr_e - (tr_size*3);
	end
        this.tr.HADDR = addr;
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------WRAP4 BURST write-----------\n");
  endtask : wrap4_wt
  
  task wrap8_rd(input addr, addr_e);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_WRAP8;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(7)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HWRITE = '0; 			
       	this.tr.HBURST = HBURST_WRAP8;
       	this.tr.HSIZE = HSIZE_WORD; 
       	this.tr.HTRANS = HTRANS_SEQ;
	gen2drv.put(tr);
	case(tr.HSIZE)
           0 : tr_size = 1;
           1 : tr_size = 2;
	   2 : tr_size = 4;
        endcase 
        gen2drv.put(tr);
        addr = addr+tr_size ;
	if(addr >= addr_e)
	begin
	addr = addr_e - (tr_size*3);
	end
        this.tr.HADDR = addr;
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------WRAP8 BURST read-----------\n");
  endtask : wrap8_rd
  
  task wrap8_wt(input addr, data, addr_e);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_WRAP8;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(7)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);	
       	this.tr.HWRITE = '1; 			
       	this.tr.HBURST = HBURST_WRAP8;
       	this.tr.HTRANS = HTRANS_SEQ; 
         case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
         endcase 
        gen2drv.put(tr);
       	addr = addr+tr_size ;
	if(addr >= addr_e)
	begin
	addr = addr_e - (tr_size*3);
	end
        this.tr.HADDR = addr;
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------WRAP8 BURST write-----------\n");
  endtask : wrap8_wt

  task wrap16_rd(input addr, addr_e);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '0; 
    this.tr.HBURST = HBURST_WRAP16;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(15)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);
       	this.tr.HWRITE = '0; 			
       	this.tr.HBURST = HBURST_WRAP16;
       	this.tr.HSIZE = HSIZE_WORD; 
       	this.tr.HTRANS = HTRANS_SEQ;
	gen2drv.put(tr);
	case(tr.HSIZE)
           0 : tr_size = 1;
           1 : tr_size = 2;
	   2 : tr_size = 4;
        endcase 
        gen2drv.put(tr);
        addr = addr+tr_size ;
	if(addr >= addr_e)
	begin
	addr = addr_e - (tr_size*3);
	end
        this.tr.HADDR = addr;
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------WRAP16 BURST read-----------\n");
  endtask : wrap16_rd
  
  task wrap16_wt(input addr, data, addr_e);
  bit [2:0] tr_size;
  bit [2:0] addr_sz;
  bit char;
  tr = new;
  if (!rnd)
    begin
      this.tr.HADDR.rand_mode(0);
      this.tr.HADDR = addr;
      this.tr.HWDATA.rand_mode(0);
      this.tr.HWDATA = data;
    end
    this.tr.HWRITE.rand_mode(0);
    this.tr.HBURST.rand_mode(0);
    this.tr.HWRITE = '1; 
    this.tr.HBURST = HBURST_WRAP16;
    this.tr.HTRANS = HTRANS_NONSEQ;
    rnd = tr.randomize();
    case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
    endcase 	
    gen2drv.put(tr);
    $display("SEQ address %0h",tr.HADDR);
    addr_sz = this.tr.HSIZE;
    addr    = this.tr.HADDR;
    addr    =  addr+ tr_size;
    repeat(15)	
       begin
         tr = new;
       	this.tr.HADDR.rand_mode(0);
	this.tr.HWRITE.rand_mode(0);
	this.tr.HBURST.rand_mode(0);	
       	this.tr.HWRITE = '1; 			
       	this.tr.HBURST = HBURST_WRAP16;
       	this.tr.HTRANS = HTRANS_SEQ; 
         case(tr.HSIZE)
	3'b000 : tr_size = 1;
	3'b001 : tr_size = 2;
	3'b010 : tr_size = 4;
         endcase 
        gen2drv.put(tr);
       	addr = addr+tr_size ;
	if(addr >= addr_e)
	begin
	addr = addr_e - (tr_size*3);
	end
        this.tr.HADDR = addr;
	$display("SEQ address %0h",tr.HADDR);
      end
    $display("-------WRAP16 BURST write-----------\n");
  endtask : wrap16_wt
 
  task genr(input addr,data,addr_e,rnd);
  repeat (no_trans)
    begin
        tr = new();
	if( !tr.randomize() ) 
        $fatal("Generator randomization failed"); 
        gen2drv.put(tr);
        if(tr.HWRITE) // burst for write
           begin
             case(tr.HTRANS)
    		0 : single_wt(addr,data,rnd);
    		1 : incr_wt  (addr,data,rnd);
    		2 : wrap_wt  (addr,addr_e,rnd);
    		3 : incr4_wt (addr,data,rnd);
    		4 : wrap8_wt (addr,addr_e,rnd);
    		5 : incr8_wt (addr,data,rnd);
    		6 : wrap16_wt(addr,addr_e,rnd);
    		7 : incr18_wt(addr,data,rnd);
	     endcase
           end
        if(!tr.HWRITE) 
           begin
             case(tr.HTRANS)
                0 : single_rd(addr, rnd);
    		1 : incr_rd  (addr, rnd);
    		2 : wrap_rd  (addr,addr_e);
    		3 : incr4_rd (addr,rnd);
    		4 : wrap8_rd (addr,addr_e);
    		5 : incr8_rd (addr,rnd);
    		6 : wrap16_rd(addr,addr_e);
    		7 : incr18_rd(addr,rnd);
	    endcase
           end
         no_trans++;
         $display(" Generating %0d transactions",no_trans);
    end
  endtask : genr

`ifdef DEBUG
`undef DEBUG
`endif

endclass : generator
