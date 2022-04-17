module rl_ram_1r1w_generic #(
  parameter ABITS      = 10,
  parameter DBITS      = 32,
  parameter INIT_FILE  = ""
)
(
  input                        rst_ni,
  input                        clk_i,

  //Write side
  input      [ ABITS     -1:0] waddr_i,
  input      [ DBITS     -1:0] din_i,
  input                        we_i,
  input      [(DBITS+7)/8-1:0] be_i,

  //Read side
  input      [ ABITS     -1:0] raddr_i,
  output reg [ DBITS     -1:0] dout_o
);

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  genvar i;

  logic [DBITS-1:0] mem_array [2**ABITS -1:0];  //memory array


  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //preload memory
  //This seems to be synthesizable in FPGAs
  initial
    if (INIT_FILE != "")
    begin
        $display ("INFO   : Loading %s (%m)", INIT_FILE);
        $readmemh(INIT_FILE, mem_array);
    end


  /*
   * write side
   */
generate
  for (i=0; i<(DBITS+7)/8; i++)
  begin: write
     if (i*8 +8 > DBITS)
     begin
         always @(posedge clk_i)
           if (we_i && be_i[i]) mem_array[ waddr_i ] [DBITS-1:i*8] <= din_i[DBITS-1:i*8];
     end
     else
     begin
         always @(posedge clk_i)
           if (we_i && be_i[i]) mem_array[ waddr_i ][i*8+:8] <= din_i[i*8+:8];
     end
  end
endgenerate

  /*
   * read side
   */
  //per Altera's recommendations. Prevents bypass logic
  always @(posedge clk_i)
    dout_o <= mem_array[ raddr_i ];
endmodule
