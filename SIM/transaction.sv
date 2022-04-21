/*
 *  Transaction class 
 */
import ahb3lite_pkg::*;
class transaction;
  rand bit [31:0] HWDATA;
  rand bit [31:0] HADDR;
  rand bit [2:0]  HBURST; 
  rand bit [2:0]  HSIZE;
  rand bit        HWRITE;
  rand bit        HSEL;
       bit [1:0]  HTRANS;
       bit [31:0] HRDATA;
       bit        HREADY;
       bit        HREADYOUT;
       bit        HRESP;
       bit  [31:0] itr;

 function void post_randomize();
    $display(" After randomizing");
    $displayh("\t HADDR  = %0h", HADDR);
    if(HWRITE == 1'b1) $displayh("\t HWRITE = %0d\t HWDATA = %0d", HWRITE, HWDATA);
    if(HWRITE == 1'b0) $displayh("\t HWRITE = %0d",HWRITE);
    $display("-----------------------------------------");
 endfunction
 
 constraint random { 
		HADDR % 4 == 0 && HADDR < 8'd256;
		}
constraint HSEL_select{
			HSEL == 1;
		}

constraint customized 	{
			HADDR == HADDR_SIZE;
	}
endclass : transaction
