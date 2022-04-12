//--------------TRANSACTION----------------------
class transaction;
  rand bit [31:0] HWDATA, HADDR;
  bit [31:0] HRDATA;
  bit [2:0] HBURST, HSIZE;
  bit HWRITE;
  
    virtual function void display;
      $display("Tha address = %0h has data = %0h", HADDR, HWDATA);
    endfunction
endclass : transaction
