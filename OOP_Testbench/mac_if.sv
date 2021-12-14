interface mac_if (input clk_156m25,
		  input clk_xgmii_rx,
		  input clk_xgmii_tx	
		 );
		


// Resets
logic           wb_rst_i;
logic           reset_156m25_n;
logic           reset_xgmii_rx_n;
logic           reset_xgmii_tx_n;

// Tx related signals
logic  [63:0]   pkt_tx_data;
logic           pkt_tx_val;
logic           pkt_tx_sop;
logic           pkt_tx_eop;
logic  [2:0]    pkt_tx_mod;
logic           pkt_tx_full;

// Rx related signals
logic           pkt_rx_avail;          
logic  [63:0]   pkt_rx_data;          
logic           pkt_rx_eop;            
logic           pkt_rx_err;            
logic  [2:0]    pkt_rx_mod;            
logic           pkt_rx_sop;             
logic           pkt_rx_val;             
logic           pkt_rx_ren;

// XGMII Tx related signals
logic   [7:0]    xgmii_txc;            
logic  [63:0]    xgmii_txd;          

// Wishbone related signals
logic           wb_ack_o;
logic   [7:0]   wb_adr_i;
logic   [31:0]  wb_dat_i;
logic   [31:0]  wb_dat_o;
logic   [31:0]  wb_int_o;
logic           wb_cyc_i;
logic           wb_stb_i;
logic           wb_we_i;
logic		wb_clk_i;

// XGMII Rx related signals
logic   [7:0]   xgmii_rxc;
logic   [63:0]  xgmii_rxd;


default clocking cb @(posedge clk_156m25);

input  #2      pkt_rx_avail;
input  #2      pkt_rx_data;
input  #2      pkt_rx_eop;
input  #2      pkt_rx_err;
input  #2      pkt_rx_mod;
input  #2      pkt_rx_sop;
input  #2      pkt_rx_val;
input  #2      pkt_tx_full;
input  #2      xgmii_txc;
input  #2      xgmii_txd;
output #2      xgmii_rxc;
output #2      xgmii_rxd; 
output #2      pkt_rx_ren;
output #2      pkt_tx_data;
output #2      pkt_tx_eop;
output #2      pkt_tx_mod;
output #2      pkt_tx_sop;
output #2      pkt_tx_val;


endclocking

task disable_wb();
	assign wb_adr_i = 8'b0;
	assign wb_clk_i = 1'b0;
	assign wb_cyc_i = 1'b0;
	assign wb_dat_i = 32'b0;
	assign wb_rst_i = 1'b1;
	assign wb_stb_i = 1'b0;
	assign wb_we_i  = 1'b0;
endtask

task loopback_connection();
	assign xgmii_rxc = xgmii_txc;
	assign xgmii_rxd = xgmii_txd;
endtask

task init_signals();
	pkt_rx_ren  = 1'b0;
	pkt_tx_data = 64'b0;
	pkt_tx_val  = 1'b0;
	pkt_tx_sop  = 1'b0;
	pkt_tx_eop  = 1'b0;
	pkt_tx_mod  = 3'b0;
endtask

task reset();
	wait_ps(3200);
	reset_156m25_n   = 1'b0;
	reset_xgmii_rx_n = 1'b0;
	reset_xgmii_tx_n = 1'b0;
	@(cb);
	reset_156m25_n   = 1'b1;
        reset_xgmii_rx_n = 1'b1;
        reset_xgmii_tx_n = 1'b1;
endtask

task wait_ns();
	input [31:0] delay;
	begin
		#(1000*delay);
	end
endtask

task wait_ps();
	input [31:0] delay;
	begin
		#(delay);
	end
endtask



modport        mac_port    (
            		    // Outputs
            		    output	pkt_rx_avail,
            		    output      pkt_rx_data,
            		    output	pkt_rx_eop,
            		    output	pkt_rx_err,
            		    output	pkt_rx_mod,
                  	    output	pkt_rx_sop,
            		    output	pkt_rx_val,
            		    output	pkt_tx_full,
           		    output      wb_ack_o,
			    output      wb_dat_o,
			    output      wb_int_o,
			    output      xgmii_txc,
			    output      xgmii_txd,
			    // Inputs
			    input       wb_cyc_i,
			    input       wb_stb_i,
			    input       wb_we_i,
			    input       wb_clk_i,
			    input 	wb_adr_i,
   			    input 	wb_dat_i,
            		    input       clk_156m25,
            	            input       clk_xgmii_rx,
            		    input       clk_xgmii_tx,
            		    input       pkt_rx_ren,
            		    input       pkt_tx_data,
            		    input       pkt_tx_eop,
            		    input       pkt_tx_mod,
            		    input       pkt_tx_sop,
            		    input       pkt_tx_val,
            		    input       reset_156m25_n,
            		    input       reset_xgmii_rx_n,
            		    input	reset_xgmii_tx_n,
			    input	xgmii_rxc,
			    input       xgmii_rxd				
	   		  );


modport      test_port    (
			   input        clk_156m25, 
			   clocking     cb
			  );







endinterface
