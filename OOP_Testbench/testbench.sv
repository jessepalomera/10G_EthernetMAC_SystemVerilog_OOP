`include "timescale.v"

module tb;

bit 	clk_156m25;
bit 	clk_xgmii_rx;
bit 	clk_xgmii_tx;

initial begin
	clk_156m25   = 1'b0;
	clk_xgmii_rx = 1'b0;
	clk_xgmii_tx = 1'b0;
	forever begin
		#3200;	
		clk_156m25   = ~clk_156m25;
		clk_xgmii_rx = ~clk_xgmii_rx;
		clk_xgmii_tx = ~clk_xgmii_tx;
	end
end


mac_if	mif (clk_156m25, clk_xgmii_rx, clk_xgmii_tx);


xge_mac  dut    ( // Inputs
		  .clk_156m25	    (mif.clk_156m25),
		  .clk_xgmii_rx     (mif.clk_xgmii_rx),
		  .clk_xgmii_tx     (mif.clk_xgmii_tx),
		  .pkt_rx_ren	    (mif.pkt_rx_ren),
		  .pkt_tx_data      (mif.pkt_tx_data[63:0]),
		  .pkt_tx_eop	    (mif.pkt_tx_eop),
		  .pkt_tx_mod       (mif.pkt_tx_mod[2:0]),
		  .pkt_tx_sop       (mif.pkt_tx_sop),
		  .pkt_tx_val       (mif.pkt_tx_val),
		  .reset_156m25_n   (mif.reset_156m25_n),		  
		  .reset_xgmii_rx_n (mif.reset_xgmii_rx_n),
		  .reset_xgmii_tx_n (mif.reset_xgmii_tx_n),
		  .wb_adr_i	    (mif.wb_adr_i[7:0]),
		  .wb_clk_i	    (mif.wb_clk_i),
		  .wb_cyc_i	    (mif.wb_cyc_i),
		  .wb_dat_i	    (mif.wb_dat_i[31:0]),
		  .wb_rst_i	    (mif.wb_rst_i),
		  .wb_stb_i	    (mif.wb_stb_i),
		  .wb_we_i	    (mif.wb_we_i),
		  .xgmii_rxc	    (mif.xgmii_rxc[7:0]),
		  .xgmii_rxd	    (mif.xgmii_rxd[63:0]), 
		  
		  // Outputs
		  .pkt_rx_avail     (mif.pkt_rx_avail),
		  .pkt_rx_data	    (mif.pkt_rx_data[63:0]),
		  .pkt_rx_eop	    (mif.pkt_rx_eop),
		  .pkt_rx_err	    (mif.pkt_rx_err),
		  .pkt_rx_mod	    (mif.pkt_rx_mod[2:0]),
		  .pkt_rx_sop       (mif.pkt_rx_sop),
		  .pkt_rx_val  	    (mif.pkt_rx_val),
		  .pkt_tx_full	    (mif.pkt_tx_full),
		  .wb_ack_o	    (mif.wb_ack_o),
		  .wb_dat_o	    (mif.wb_dat_o[31:0]),
	   	  .wb_int_o	    (mif.wb_int_o),
		  .xgmii_txc	    (mif.xgmii_txc[7:0]),
		  .xgmii_txd	    (mif.xgmii_txd[63:0])
	        );
	 	

testcase test   ( mif.test_port,		//used by driver
		  mif.test_port );		//used by monitor


endmodule
