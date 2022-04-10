interface memory(input bit HCLK,HRESET);
   logic [31:0] HADDR;
   logic [31:0] HRDATA;
   logic [31:0] HWDATA;
   logic [3:0] HPROT;
   logic [2:0] HSIZE;
   logic [2:0] HBURST;
   logic [1:0] HTRANS, HSEL;
   logic HREADY, HREADYOUT, HRESP;
   logic HWRITE;
   // DUT modport slave
   modport  slave (input HADDR , HSEL, HWRITE, 
                   HSIZE, HBURST, HPROT, HTRANS, 
                   HREADY, HWDATA, HRESET, HCLK,
                   output HREADYOUT, HRESP, HRDATA);
   // test modport 
   modport  test (input HCLK , HRESET, HREADYOUT, 
                   HRESP, HRDATA,
                   output HADDR ,HSEL , HWRITE, 
                   HSIZE, HBURST, HPROT, HTRANS, 
                   HREADY,HWDATA );
   // monitor modport 
   modport  mon (input HCLK , HRESET, HREADYOUT, 
                   HRESP, HRDATA, HADDR, HSEL, 
                   HWRITE, HSIZE, HBURST, HPROT, 
                   HTRANS, HREADY,HWDATA);
endinterface: memory
