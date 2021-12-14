`include "packet.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "packetgenerator.sv"
`include "env.sv"



program testcase(interface tcif_drv, interface tcif_mon);


	env env0;


	class missing_sop extends packet;

		constraint legal_sop { tx_sop == 0; }

	endclass

	env 	    	env0;
	missing_sop 	testcase_packet;


	initial begin
		tcif_drv.reset();
		tcif_drv.loopback_connection();
		tcif_drv.init_signals();
		tcif_drv.disable_wb();
		
		env0 = new(tcif_drv, tcif_mon);
	
		testcase_packet = new();	
		env0.pktgen.ethernet = testcase_packet;
		env0.run();

		#100 $finish;
	end

	





endprogram
