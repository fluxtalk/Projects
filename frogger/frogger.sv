module  frogger 		( input         Clk,
                                     Reset,
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  output [8:0]  LEDG,
							  output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  Red,
							                Green,
												 Blue,
							  output        VGA_clk,
							                sync,
												 blank,
												 vs,
												 hs,
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] sdram_wire_addr,				// SDRAM Address 13 Bits
							  inout [31:0]  sdram_wire_dq,				// SDRAM Data 32 Bits
							  output [1:0]  sdram_wire_ba,				// SDRAM Bank Address 2 Bits
							  output [3:0]  sdram_wire_dqm,				// SDRAM Data Mast 4 Bits
							  output			 sdram_wire_ras_n,			// SDRAM Row Address Strobe
							  output			 sdram_wire_cas_n,			// SDRAM Column Address Strobe
							  output			 sdram_wire_cke,				// SDRAM Clock Enable
							  output			 sdram_wire_we_n,				// SDRAM Write Enable
							  output			 sdram_wire_cs_n,				// SDRAM Chip Select
							  output			 sdram_clk						// SDRAM Clock
											);
    
    logic Reset_h;
	 logic [7:0] keycode;
	 logic [10:0] FrogX_wire, FrogY_wire, FrogS_wire;
	 logic [10:0] DrawX_wire, DrawY_wire;
    logic [10:0] LogX_wire, LogY_wire, LogS_wire;
	 
    assign {Reset_h}=~ (Reset);  // The push buttons are active low
	 assign OTG_FSPEED = 1'bz;
	 assign OTG_LSPEED = 1'bz;
	    
	 usb_system usbsys_instance(
										 .clk_clk(Clk),         
										 .reset_reset_n(1'b1),   
										 .sdram_wire_addr(sdram_wire_addr), 
										 .sdram_wire_ba(sdram_wire_ba),   
										 .sdram_wire_cas_n(sdram_wire_cas_n),
										 .sdram_wire_cke(sdram_wire_cke),  
										 .sdram_wire_cs_n(sdram_wire_cs_n), 
										 .sdram_wire_dq(sdram_wire_dq),   
										 .sdram_wire_dqm(sdram_wire_dqm),  
										 .sdram_wire_ras_n(sdram_wire_ras_n),
										 .sdram_wire_we_n(sdram_wire_we_n), 
										 .sdram_out_clk_clk(sdram_clk),
										 .keycode_export(keycode),  
										 .usb_DATA(OTG_DATA),    
										 .usb_ADDR(OTG_ADDR),    
										 .usb_RD_N(OTG_RD_N),    
										 .usb_WR_N(OTG_WR_N),    
										 .usb_CS_N(OTG_CS_N),    
										 .usb_RST_N(OTG_RST_N),   
										 .usb_INT(OTG_INT) );
	
										  
	 HexDriver hex_inst_0 (keycode[3:0], HEX0);
	 HexDriver hex_inst_1 (keycode[7:4], HEX1);  
	 
	 frog frog_instance(.Reset(Reset_h), .frame_clk(vs), .keycode(keycode),	.FrogX(FrogX_wire), .FrogY(FrogY_wire), .FrogS(FrogS_wire),
							  .LogX(LogX_wire), .LogY(LogY_wire), .LogS(LogS_wire)); 

							  
	 vga_controller vga_control(.Clk(Clk), .Reset(Reset_h), .hs(hs), .vs(vs), .pixel_clk(VGA_clk), .blank(blank),
						  .sync(sync), .DrawX(DrawX_wire), .DrawY(DrawY_wire));
		
	 color_mapper coloring(.shape2_x(FrogX_wire), .shape2_y(FrogY_wire), .DrawX(DrawX_wire), .DrawY(DrawY_wire), .Frog_size(FrogS_wire),
						/*.Car1_X(Car1_X_wire), .Car2_X(Car2_X_wire), .Car3_X(Car3_X_wire), .Car1_Y(Car1_Y_wire), .Car2_Y(Car2_Y_wire), 
						.Car3_Y(Car3_Y_wire),*/ .Log1_X(LogX_wire), /*.Log2_X(Log2_X_wire), .Log3_X(Log3_X_wire),*/ .Log1_Y(LogY_wire),
						/*.Log2_Y(Log2_Y_wire), .Log3_Y(Log3_Y_wire),*/ .Log_size(LogS_wire),
                  .Red(Red), .Green(Green), .Blue(Blue));

	
	 /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #1/2:
          What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
			 connect to the keyboard? List any two.  Give an answer in your Post-Lab.
     **************************************************************************************/
endmodule


