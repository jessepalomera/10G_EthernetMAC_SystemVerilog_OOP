`include "packet.sv"
`include "packetgenerator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "env.sv"

program testcase(interface tcif_drv, interface tcif_mon);


	env env0;



	initial begin
		tcif_drv.reset();
		tcif_drv.loopback_connection();
		tcif_drv.init_signals();
		tcif_drv.disable_wb();
		env0 = new(tcif_drv, tcif_mon);
		@(posedge tcif_drv.clk_156m25);
		env0.run();
		tcif_drv.wait_ns(50000);	
	end

	





endprogram
