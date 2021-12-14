class driver;

	
	mailbox		drv2sb;
	mailbox 	pktgen2drv;
	packet		pkt;	
	

	virtual mac_if 	vi;

	function new(input virtual mac_if   vif,
		     input mailbox	    pktgen2drv,
		     input mailbox 	    drv2sb     );

		this.vi         = vif;
		this.pktgen2drv = pktgen2drv;
		this.drv2sb     = drv2sb;
		pkt 	        = new();	
	
	endfunction




	task send_packet();
	
	        int tx_pkt_size;
		pktgen2drv.get(pkt);		
		repeat (pkt.ipg) tx_pkt_size = pkt.tx_data.size();
			
				
			for(int i = 0; i < tx_pkt_size; i = i + 8) begin
				
				@(vi.cb);
				vi.cb.pkt_tx_sop <= 1'b0;
				
				if (i == 0) begin
					vi.cb.pkt_tx_sop <= pkt.tx_sop;
					vi.cb.pkt_tx_val <= pkt.tx_val;
					vi.cb.pkt_tx_eop <= 1'b0;
					if(!pkt.tx_sop) begin
						$display("---- SOP was not detected. Current Packet will not be sent ----\n ");
						pkt.tx_data.delete();
						break;
					end
				end

				vi.cb.pkt_tx_data[`LANE7] <= pkt.tx_data[i];
                                vi.cb.pkt_tx_data[`LANE6] <= pkt.tx_data[i+1];
                                vi.cb.pkt_tx_data[`LANE5] <= pkt.tx_data[i+2];
                                vi.cb.pkt_tx_data[`LANE4] <= pkt.tx_data[i+3];
                                vi.cb.pkt_tx_data[`LANE3] <= pkt.tx_data[i+4];
                                vi.cb.pkt_tx_data[`LANE2] <= pkt.tx_data[i+5];
                                vi.cb.pkt_tx_data[`LANE1] <= pkt.tx_data[i+6];
                                vi.cb.pkt_tx_data[`LANE0] <= pkt.tx_data[i+7];
				
				if (i + 8 >= tx_pkt_size) begin
					vi.cb.pkt_tx_eop <= pkt.tx_eop;
					vi.cb.pkt_tx_mod <= pkt.tx_mod;
					vi.wait_ps(6400);
					vi.cb.pkt_tx_val <= 1'b0;
					if(!pkt.tx_eop) begin
						$display("---- EOP was not detected. Current Packet is bad, discard packet ----\n");
						break;
					end
						
				end
			end
			$display("\n---- Time = %0t ps: Sending packet with length: %0d ----\n", $time, tx_pkt_size);	
			drv2sb.put(pkt);	
			if(vi.cb.pkt_tx_full) 
				forever begin
					if(!vi.cb.pkt_tx_full)
					break;

				end
	endtask

		
endclass
