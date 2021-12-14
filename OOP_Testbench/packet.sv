class packet;


	rand bit   [ 7:0] tx_data[];
	rand bit	  tx_val;
	rand bit	  tx_sop;
	rand bit   [ 2:0] tx_mod;
	rand bit          tx_eop;
	static bit [15:0] pktid;
	rand int	  ipg;	

	function new();
	

	endfunction

		


	constraint tx_data_size {
	
		tx_data.size() inside {[43:6000]};

	} 

	constraint legal_val   { 

		tx_val == 1;
	} 
	
	constraint legal_sop   {  

		tx_sop == 1;
	}

	constraint legal_mod   {
		
		tx_mod == (tx_data.size() % 8);

	}

	constraint legal_eop   {

		tx_eop == 1;

	}
	
	constraint legal_ipg   {
		
		ipg >= 4;
		ipg <=12;

	}


	function void print();
		
		$display("tx_data = %p", tx_data);
		
	endfunction






		
endclass
