class scoreboard;



	mailbox rcv_from_drv;    // Mailbox to receive incoming packet from driver
	mailbox rcv_from_mon;	 // Mailbox to receive incoming packet from monitor


	function new(input mailbox drv2sb, input mailbox mon2sb);

		this.rcv_from_drv = drv2sb;
		this.rcv_from_mon = mon2sb;

	endfunction
	
	coverage cov;

	task compare(input mailbox rcv_from_drv, input mailbox rcv_from_mon);
		bit error;
		packet pkt_from_drv;
		packet pkt_from_mon;
		cov = new();
		// Get a packet from rcv_from_drv mailbox, then assign it to pkt_from_drv
		
		rcv_from_drv.get(pkt_from_drv);
		$write("pkt_from_drv:"); //pkt_from_drv.print();

		// Get a packet from rcv_from_mon mailbox, then assign it to pkt_from_mon
		
		rcv_from_mon.get(pkt_from_mon);
		$write("pkt_from_mon:"); //pkt_from_mon.print(); 
		$display("---- Received Packets from Driver and Monitor. Comparing ----\n");	
		begin	
			if(pkt_from_drv.tx_data.size() != pkt_from_mon.tx_data.size()) begin
				
				// Check if Error Signal was asserted in Missing_SOP Testcase
				if(pkt_from_mon.tx_data.size() != 0 && (pkt_from_mon.tx_data.size() < pkt_from_drv.tx_data.size())) begin 
					$display("---- FAIL: Design Did not Assert Packet Error Signal and Did Not Discard Packet ----\n");
					error++;
					$display("error = %0d", error);
					end		
				// Check if Design Padded Zeros in Undersized Packet Testcase
				if(pkt_from_drv.tx_data.size() < pkt_from_mon.tx_data.size()) begin
					if(pkt_from_mon.tx_data.size() != 64) begin
						$display("---- FAIL: DESIGN DID NOT PAD UP TO 64BYTES REQUIRED FOR ETHERNET ----\n");
						error++;
						$display("error = %0d", error);
						end
					else if(error == 0)
						$display("---- PASS: DESIGN PADDED RECEIVED PACKET TO 64BYTES ----\n");
				end
				else if(error == 0) 
                                	$display("---- PASS: DESIGN ASSERTED PACKET ERROR SIGNAL AND DISCARDED LOGIC ----\n");
				
			end
			
			if(pkt_from_drv.tx_data.size() == pkt_from_mon.tx_data.size()) begin
				
				// Check if Packet Matches in Loopback Test Regular Sized Packet
				if(pkt_from_drv.tx_data != pkt_from_mon.tx_data) begin
					$display("Time=%0t FAIL: Packet Mismatches!\n", $time);
					error++;
					$display("error = %0d", error);
					end
			
				if(error == 0)
					$display("Time =%0t PASS: Packet Matches!\n", $time);
			end
			
			cov.collect_coverage(pkt_from_drv);

		end

	endtask










endclass
