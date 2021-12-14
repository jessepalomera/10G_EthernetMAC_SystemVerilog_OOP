class packetgenerator;




	mailbox pktgen2drv;     // Use this mailbox to send packets to driver
	packet ethernet;

	function new(input mailbox pktgen2drv);
		
		this.pktgen2drv = pktgen2drv;
		ethernet = new();
		
	endfunction

	task generate_packet();
	
		packet pkt;
		pkt = new ethernet;	// Create packet, this is necessary in order to overwrite base packet
		
		assert(pkt.randomize());
		pktgen2drv.put(pkt);

	endtask
	

endclass
