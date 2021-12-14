class coverage;


	packet covpacket;

	covergroup		MAC_cov;
		tx_data:	coverpoint covpacket.tx_data.size() {

					bins	smallsize	= {[9:63]};
					bins	mediumsize	= {[64:1000]};
					bins    largesize	= {[1500:9000]};

				}
	endgroup

	function new();

		MAC_cov = new();

	endfunction

	task collect_coverage(input packet pkt_from_drv);

		this.covpacket = pkt_from_drv;
		MAC_cov.sample();
	endtask


endclass
