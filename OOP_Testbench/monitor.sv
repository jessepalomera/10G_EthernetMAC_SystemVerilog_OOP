class monitor;




	bit [7:0] 		queue[$];
	mailbox			mon2sb;
	virtual mac_if		mi;
	static int		count;

	function new(input virtual mac_if   mif,
		     input mailbox 	    mon2sb );
		
		this.mi     = mif;
		this.mon2sb = mon2sb;
	endfunction
	

	task collect_packet();
		packet rcvpacket;
		rcvpacket = new();
		//$display("---- Time = %0t ps: Receiving Packet ----\n",$time);	
		forever begin
			
			@(mi.cb) 
			if(mi.cb.pkt_rx_avail) 
				mi.cb.pkt_rx_ren <= 1'b1;

			if(mi.cb.pkt_rx_val == 1) begin 
				if(mi.cb.pkt_rx_sop == 1 || mi.cb.pkt_rx_eop == 0) begin
					queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE4]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE3]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE2]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE1]);
                                        queue.push_back(mi.cb.pkt_rx_data[`LANE0]);
					end
				if(mi.cb.pkt_rx_err) begin
					$display("---- Error Received!! Current Packet is Bad, Discarding Packet\n");
					queue.delete();
					rcvpacket.tx_data = queue;
					mon2sb.put(rcvpacket);
					break;
					end
					
				if(mi.cb.pkt_rx_eop) begin
					mi.cb.pkt_rx_ren <= 1'b0; 
					if(mi.cb.pkt_rx_mod == 0) begin
						queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE4]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE3]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE2]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE1]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE0]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
                				mon2sb.put(rcvpacket);
                				queue.delete();
						break;
						end
					if(mi.cb.pkt_rx_mod == 1) begin
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
						mon2sb.put(rcvpacket);
                                                queue.delete();
						break;
                                        	end
					if(mi.cb.pkt_rx_mod == 2) begin
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
						mon2sb.put(rcvpacket);
                                                queue.delete();
                                                break;
                                        	end
					if(mi.cb.pkt_rx_mod == 3) begin
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
                                        	queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
						rcvpacket.tx_data = queue;
						mon2sb.put(rcvpacket);
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
                                                queue.delete();
                                                break;
                                        	end
					if(mi.cb.pkt_rx_mod == 4) begin
						queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
				  		queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
			  			queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
		  				queue.push_back(mi.cb.pkt_rx_data[`LANE4]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
						mon2sb.put(rcvpacket);
                                                queue.delete();
						break;
						end	
					if(mi.cb.pkt_rx_mod == 5) begin
						queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE4]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE3]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
						mon2sb.put(rcvpacket);
                                                queue.delete();
						break;
						end
					if(mi.cb.pkt_rx_mod == 6) begin
			  			queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
		   				queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
			   			queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
			   			queue.push_back(mi.cb.pkt_rx_data[`LANE4]);
			   			queue.push_back(mi.cb.pkt_rx_data[`LANE3]);
			    			queue.push_back(mi.cb.pkt_rx_data[`LANE2]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
						mon2sb.put(rcvpacket);
                                                queue.delete();
						break;
	       					end
					if(mi.cb.pkt_rx_mod == 7) begin
			 			queue.push_back(mi.cb.pkt_rx_data[`LANE7]);
		  				queue.push_back(mi.cb.pkt_rx_data[`LANE6]);
	   					queue.push_back(mi.cb.pkt_rx_data[`LANE5]);
    						queue.push_back(mi.cb.pkt_rx_data[`LANE4]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE3]);
						queue.push_back(mi.cb.pkt_rx_data[`LANE2]);
				 		queue.push_back(mi.cb.pkt_rx_data[`LANE1]);
						rcvpacket.tx_data = queue;
						$display("---- Time = %0t ps: Received Packet with Length of %0d ----\n",$time, rcvpacket.tx_data.size());
						mon2sb.put(rcvpacket);
                                                queue.delete();
						break;
						end
				end

				end
		end
		
		
	endtask







endclass
