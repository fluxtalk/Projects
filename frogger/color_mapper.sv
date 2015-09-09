 module  color_mapper( input [10:0] shape2_x, shape2_y, DrawX, DrawY, Frog_size,Log1_X, Log_size,
                       output logic [7:0]  Red, Green, Blue );
    
    logic Frog_on;
	 logic shape_on; //S
	 logic shape2_on; // frog
	 logic shape3_on; //C
	 logic shape4_on; //O
	 logic shape5_on; //R
	 logic shape6_on;	 //E
	 logic shape7_on; //:
	 logic shape8_on; // #
	 logic log1_on;
	 logic log2_on;
	 logic log3_on;
	 logic log4_on;

	 logic[10:0] shape_x = 400;		//S 
	 logic[10:0] shape_y = 440;	 
	 logic[10:0] shape3_x = 425;		//C 
	 logic[10:0] shape4_x = 450;		//O	 
	 logic[10:0] shape5_x = 475;		//R
	 logic[10:0] shape6_x = 500;		// E
	 logic[10:0] shape7_x = 525;		// :
	 logic[10:0] shape8_x = 550;		// #
	 logic[10:0] shape2_size_x = 24;
	 logic[10:0] shape2_size_y = 22;	
	 
	 logic[10:0] log1_x;
	 logic[10:0] log2_x;
	 logic[10:0] log1_y;
	 logic[10:0] log2_y;
	 
	 assign log1_x = Log1_X;
	 assign log2_x = Log1_X + shape2_size_x;
	 assign log1_y = Log1_Y;
	 assign log2_y = Log1_Y + shape2_size_y;

	 logic [10:0] sprite_addr;
	 logic [0:23] sprite_data;
	 font_rom(.addr(sprite_addr),.data(sprite_data));

    always_comb
    begin:Frog_on_proc
		// S
       if (DrawX >= shape_x && DrawX < shape_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b1;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h05);
		  end 
		  
		 // C
       else if (DrawX >= shape3_x && DrawX < shape3_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b1;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;		
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h06);
		  end 
		  
		 // O
       else if (DrawX >= shape4_x && DrawX < shape4_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b1;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;				
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h07);
		  end 
		  
		 // R
       else if (DrawX >= shape5_x && DrawX < shape5_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b1;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;	
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h08);
		  end 
		  
		 // E
       else if (DrawX >= shape6_x && DrawX < shape6_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b1;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;	
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h09);
		  end 
		  
		 // :
       else if (DrawX >= shape7_x && DrawX < shape7_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b1;	
				shape8_on = 1'b0;
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h0a);
		  end 
		  
		 // #	 
       else if (DrawX >= shape8_x && DrawX < shape8_x + shape2_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape2_size_y)
		  begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b1;	
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY-shape_y + 22*'h0b);
		  end 	
	
			// frog
		  else if (DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x &&
				DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y) 
        begin
				shape_on = 1'b0;
				shape2_on = 1'b1;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY - shape2_y + 22*'h02);
		  end 
		  
		  //upper-left part of log
		  else if (DrawX >= log1_x && DrawX < log1_x + shape2_size_x &&
				DrawY >= log1_y && DrawY < log1_y + shape2_size_y) 
        begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;
				log1_on = 1'b1;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = (DrawY - log1_y + 22*'h0c);
		  end 
		  
		  //upper-right part of log
		  else if (DrawX >= log2_x && DrawX < log2_x + shape2_size_x &&
				DrawY >= log1_y && DrawY < log1_y + shape2_size_y) 
        begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;
				log1_on = 1'b0;
				log2_on = 1'b1;
				log3_on = 1'b0;
				log4_on = 1'b0;	

				sprite_addr = (DrawY - log1_y + 22*'h0c);
		  end
		  
		  //lower-left part of log
		  else if (DrawX >= log1_x && DrawX < log1_x + shape2_size_x &&
				DrawY >= log2_y && DrawY < log2_y + shape2_size_y) 
        begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b1;
				log4_on = 1'b0;

				sprite_addr = (DrawY - log2_y + 22*'h0c);
		  end
		  
		  //lower-right part of log
		  else if (DrawX >= log2_x && DrawX < log2_x + shape2_size_x &&
				DrawY >= log2_y && DrawY < log2_y + shape2_size_y) 
        begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b1;

				sprite_addr = (DrawY - log2_y + 22*'h0c);
		  end
		  
	     else 
	     begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				shape5_on = 1'b0;	
				shape6_on = 1'b0;		
				shape7_on = 1'b0;	
				shape8_on = 1'b0;	
				log1_on = 1'b0;
				log2_on = 1'b0;
				log3_on = 1'b0;
				log4_on = 1'b0;

				sprite_addr = 11'b0;
		  end 
	end 
	  
	 always_comb
    begin:RGB_Display

        if ((shape_on == 1'b1) && sprite_data[DrawX - shape_x] == 1'b1) 
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 		  
		  else if((shape3_on == 1'b1) && sprite_data[DrawX - shape3_x] == 1'b1) 
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 
		  
		  else if((shape4_on == 1'b1) && sprite_data[DrawX - shape4_x] == 1'b1) 
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 
		  
		  else if((shape5_on == 1'b1) && sprite_data[DrawX - shape5_x] == 1'b1) 
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 
		  
		  else if((shape6_on == 1'b1) && sprite_data[DrawX - shape6_x] == 1'b1) 
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 
		  
		  else if((shape7_on == 1'b1) && sprite_data[DrawX - shape7_x] == 1'b1)
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 
		  
		  else if((shape8_on == 1'b1) && sprite_data[DrawX - shape8_x] == 1'b1)  		  
        begin 
            Red = 8'h00;
            Green = 8'h00;
				Blue = 8'h00; 
            //Blue = 8'hff;
        end 
		  
		  else if ((shape2_on == 1'b1) && sprite_data[DrawX - shape2_x] == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'hff;
				Blue = 8'hff; 
            //Blue = 8'hff;
        end  

		  else if ((log1_on == 1'b1) && sprite_data[DrawX - log1_x] == 1'b1)
        begin 
            Red = 8'h66;
            Green = 8'h33;
				Blue = 8'h00; 
        end
		  
		  else if ((log2_on == 1'b1) && sprite_data[DrawX - log2_x] == 1'b1)
        begin 
            Red = 8'h66;
            Green = 8'h33;
				Blue = 8'h00; 
        end
		  
		  else if ((log3_on == 1'b1) && sprite_data[DrawX - log1_x] == 1'b1)
        begin 
            Red = 8'h66;
            Green = 8'h33;
				Blue = 8'h00; 
        end
		  
		  else if ((log4_on == 1'b1) && sprite_data[DrawX - log2_x] == 1'b1)
        begin 
            Red = 8'h66;
            Green = 8'h33;
				Blue = 8'h00; 
        end
		  /*
		  else if ((car1_on == 1'b1) && sprite_data[DrawX - car1_x] == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'hff;
				Blue = 8'h33; 
        end
		  
		  else if ((car2_on == 1'b1) && sprite_data[DrawX - car2_x] == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'hff;
				Blue = 8'h33;  
        end
		  
		  else if ((car3_on == 1'b1) && sprite_data[DrawX - car1_x] == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'hff;
				Blue = 8'h33;  
        end
		  
		  else if ((car4_on == 1'b1) && sprite_data[DrawX - car2_x] == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'hff;
				Blue = 8'h33;  
        end
		  */
		  
		  else 
        begin 
				//background
				
				//max x-coordinate: 639 
				//max y-coordinate: 479
							
				//Top Grass Area
				if(DrawY <= 34)
				begin
					Red = 8'h00;
					Green = 8'h88;
					Blue = 8'hff; 		
			
						if(DrawX <= 50 && DrawX >= 0 || DrawX <= 168 && DrawX >= 118 || DrawX <= 286 && DrawX >= 236 ||
							DrawX <= 404 && DrawX >= 354 || DrawX <= 522 && DrawX >= 472 || DrawX <= 639 && DrawX >= 590)
						begin
							Green = Green + 8'h22;
							Blue = Blue - 8'hff;
						end
						
						//Side dirt
						else if(DrawX <= 52 && DrawX >= 50 || DrawX <= 118 && DrawX >= 116 || DrawX <= 170 && DrawX >= 168 ||
								  DrawX <= 236 && DrawX >= 234 || DrawX <= 288 && DrawX >= 286 || DrawX <= 354 && DrawX >= 352 ||
								  DrawX <= 406 && DrawX >= 404 ||  DrawX <= 472 && DrawX >= 470 || DrawX <= 524 && DrawX >= 522 ||
								  DrawX <= 590 && DrawX >= 588)
						begin
							Red = Red + 8'h88;
							Green = Green - 8'h44;
							Blue = Blue - 8'hbb;
						end
						
						else
						begin
							Green = Green + 8'h00;
							Blue = Blue + 8'h00;
							Red = Red + 8'h00;
						end
				end
				
				//Dirt Border on top grass
				else if(DrawY <= 36)
				begin
					if(DrawX <= 52 && DrawX >= 0 || DrawX <= 170 && DrawX >= 116 || DrawX <= 288 && DrawX >= 234 ||
							DrawX <= 406 && DrawX >= 352 || DrawX <= 524 && DrawX >= 470 || DrawX <= 639 && DrawX >= 588)
					begin
						Red = 8'h88;
						Green = 8'h44;
						Blue = 8'h22;
					end
					
					else
					begin
						Red = 8'h00;
						Green = 8'h88;
						Blue = 8'hff; 	
					end
				end
								
				//Water
				else if(DrawY <= 225)
				begin
					Red = 8'h00;
					Green = 8'h88;
					Blue = 8'hff; 	
				end
				
				//Center Cement Pavement
				else if(DrawY <= 255)
				begin
					Red = 8'hff;
					Green = 8'hdd;
					Blue = 8'hbb; 	
				end
				
				//Top Lane of Road
				else if(DrawY <= 316)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00; 				
				end
				
				//Upper Yellow traffic line
				else if(DrawY <= 320)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00; 		
			
						if(DrawX <= 80 && DrawX >= 30 || DrawX <= 160 && DrawX >= 110 || DrawX <= 240 && DrawX >= 190 ||
							DrawX <= 320 && DrawX >= 270 || DrawX <= 400 && DrawX >= 350 || DrawX <= 480 && DrawX >= 430 || 
							DrawX <= 560 && DrawX >= 510 || DrawX <= 640 && DrawX >= 590)
						begin
							Red = Red + 8'h99;
							Green = Green + 8'h99;
						end
						
						else
						begin
							Red = 8'h00;
							Green = 8'h00;
							Blue = 8'h00;
						end
				end
					
				//Middle Lane of Road
				else if(DrawY <= 379)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00; 				
				end
				
				//Lower Yellow traffic line
				else if(DrawY <= 383)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00; 		
			
						if(DrawX <= 80 && DrawX >= 30 || DrawX <= 160 && DrawX >= 110 || DrawX <= 240 && DrawX >= 190 ||
							DrawX <= 320 && DrawX >= 270 || DrawX <= 400 && DrawX >= 350 || DrawX <= 480 && DrawX >= 430 || 
							DrawX <= 560 && DrawX >= 510 || DrawX <= 640 && DrawX >= 590)
						begin
							Red = Red + 8'h99;
							Green = Green + 8'h99;
						end
						
						else
						begin
							Red = 8'h00;
							Green = 8'h00;
							Blue = 8'h00;
						end
				end
				
				///*
				
				//Bottom Lane of Road
				else if(DrawY <= 444)
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00; 				
				end
				
				//Bottom Road pavement
				else if(DrawY <= 454)
				begin
					Red = 8'hff;
					Green = 8'hdd;
					Blue = 8'hbb;				
				end
				
				//Bottom Grass Area
				else if(DrawY <= 479)
				begin
					Red = 8'h00;
					Green = 8'haa;
					Blue = 8'h00; 				
				end

				//Anything leftover
				else
				begin
					Red = 8'h00;
					Green = 8'hff;
					Blue = 8'h00; 
				end
        end

    end 
    
endmodule