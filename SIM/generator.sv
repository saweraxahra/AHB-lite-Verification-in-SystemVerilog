//------------------- GENERATOR -------------------------
`include "transaction.sv"
//A new type for bursts
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} e_burst;
e_burst burst;

//A new type for transfers
typedef enum bit [1:0] {IDLE, BUSY, NONSEQ, SEQ} e_trans;
e_trans trans;

class generator;
  virtual memory.test port_t; // connect virtual interface
  mailbox gen2drv;            // mailbox from generator to driver
  transaction tr;             // define transaction
  int  tr_count;              // counting number of transactions
  int  beat_count;            // counting number of beats
  logic beat_case;
  
	function new(virtual memory.test port_t, mailbox gen2drv); // construct function to connect ports
     begin
       this.port_t = port_t;
       this.gen2drv = gen2drv;
     end
  endfunction 
  
  task burst; // bursts cases
  forever begin
    tr = new;
    port_t.HTRANS = NONSEQ; // Non-Sequential 
    gen2drv.put(tr);
    $display("Address:0x%0h sent to driver\n",tr.HADDR);
    beat_count = beat_count - 1;
    case (beat_case)
	SINGLE : begin 
		 repeat(beat_count)	
      		 begin
      		   port_t.HTRANS = SEQ; // SEQ for the remaining beats
        	   port_t.HSIZE = 3'b010; // HSIZE=word (32-bits)
      			case(tr.HSIZE)
				3'b000 : port_t.HSIZE = 1;
				3'b001 : port_t.HSIZE = 2;
				3'b010 : port_t.HSIZE = 4;
        		endcase 
       	gen2drv.put(tr);	
	port_t.HADDR = tr.HADDR + port_t.HSIZE;
	$display("Address:0x%0h sent to mailbox",tr.HADDR);
	end
	$display("Single Burst sent to driver\n");
	end
    	INCR4 : begin 
		repeat(3)	
      		begin
      		  port_t.HTRANS = SEQ; // SEQ for the remaining beats
        	  port_t.HSIZE = 3'b010; // HSIZE=word (32-bits)
      	          case(tr.HSIZE)
		        3'b000 : port_t.HSIZE = 1;
			3'b001 : port_t.HSIZE = 2;
			3'b010 : port_t.HSIZE = 4;
        	  endcase 
       		gen2drv.put(tr);	
		port_t.HADDR = tr.HADDR + port_t.HSIZE;
		$display("Address 0x%0h has been sent to mailbox",tr.HADDR);
		end
		$display("INCR4 burst sent to driver\n");
                end
        INCR8 : begin
		repeat(7)	
      		begin
      		  port_t.HTRANS = SEQ; // SEQ for the remaining beats
        	  port_t.HSIZE = 3'b010; // HSIZE=word (32-bits)
      	              case(tr.HSIZE)
		        3'b000 : port_t.HSIZE = 1;
			3'b001 : port_t.HSIZE = 2;
			3'b010 : port_t.HSIZE = 4;
        	      endcase 
       		gen2drv.put(tr);	
		port_t.HADDR = tr.HADDR + port_t.HSIZE;
		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		end
		$display("INCR8 burst sent to driver\n");
		end
	INCR16 :begin
		repeat(15)	
      		begin
      		  port_t.HTRANS = SEQ; // SEQ for the remaining beats
        	  port_t.HSIZE = 3'b010; // HSIZE=word (32-bits)
      	              case(tr.HSIZE)
		        3'b000 : port_t.HSIZE = 1;
			3'b001 : port_t.HSIZE = 2;
			3'b010 : port_t.HSIZE = 4;
        	      endcase 
       		gen2drv.put(tr);	
		port_t.HADDR = tr.HADDR + port_t.HSIZE;
		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		end
		$display("INCR16 burst sent to driver\n");
		end
	endcase
  end 
  endtask : burst
  
  
  //run task, generates(create and randomizes) 
  //The tr_count number of transaction packets and puts into mailbox
  task run;
   forever begin
    repeat(tr_count) 
    tr = new; 
    if( !tr.randomize() ) 
      $fatal("Randomization of generator failed");
    tr.display;
    gen2drv.put(tr);
    end
  endtask : run
endclass : generator
