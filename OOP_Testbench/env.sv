class env;



	scoreboard		sb;
	mailbox			drv2sb;
	mailbox			mon2sb;
	mailbox			pktgen2drv;
	
	packetgenerator	 	pktgen;
	driver 			drv;
	monitor			mon;
	virtual mac_if 		vi;
	virtual mac_if		mi;

	function new(input virtual mac_if vif, input virtual mac_if mif);
		
		this.vi    = vif;
		this.mi    = mif;
		pktgen2drv = new();
		drv2sb     = new();
		mon2sb     = new();
		pktgen	   = new(pktgen2drv);
		drv        = new(vif, pktgen2drv, drv2sb);
		mon        = new(mif, mon2sb);
		sb         = new(drv2sb, mon2sb);
		
	endfunction



	task run(int num_packet = 10);
	fork
		for(int z = 0; z < num_packet; z++) begin
			pktgen.generate_packet();
		end
		for(int i = 0; i < num_packet; i++) begin
			drv.send_packet();
		end
	join_any
		for(int j = 0; j < num_packet; j++) begin		
			mon.collect_packet;
			sb.compare(drv2sb,mon2sb);
		end

	endtask





endclass
