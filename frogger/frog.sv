module  frog( input Reset, frame_clk,
					input [7:0] keycode,
               output [10:0]  FrogX, FrogY, FrogS, LogX, LogY, LogS );
    
    logic [10:0] Frog_X_Pos, Frog_X_Motion, Frog_Y_Pos, Frog_Y_Motion, Frog_Size;
	 logic [10:0] Log_X_Pos, Log_X_Motion, Log_Y_Pos, Log_Y_Motion, Log_Size;
	 
    parameter [10:0] Frog_X_Start=320;       // Leftmost point on the X axis
    parameter [10:0] Frog_Y_Start=440;       // Leftmost point on the X axis
	 
    parameter [10:0] Frog_X_Min=0;       // Leftmost point on the X axis
    parameter [10:0] Frog_X_Max=639;     // Rightmost point on the X axis
    parameter [10:0] Frog_Y_Min=0;       // Topmost point on the Y axis
    parameter [10:0] Frog_Y_Max=479;     // Bottommost point on the Y axis
    parameter [10:0] Frog_X_Step=1;      // Step size on the X axis
    parameter [10:0] Frog_Y_Step=1;      // Step size on the Y axis
	 
	 parameter [10:0] Log_X_Start = 0;
	 parameter [10:0] Log_Y_Start = 71;
	 parameter [10:0] Log_X_Step = 1;
	 parameter [10:0] Log_Y_Step = 0;
	 
    assign Frog_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Log_X_Size = 24;
	 assign Log_Y_Size = 31;
	 assign Log_Y_Motion = 0;
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Frog
        if (Reset)  // Asynchronous Reset
        begin 
            Frog_Y_Motion <= 11'd0; //Frog_Y_Step;
				Frog_X_Motion <= 11'd0; //Frog_X_Step;
				Frog_Y_Pos <= Frog_Y_Start;
				Frog_X_Pos <= Frog_X_Start;
				
				Log_Y_Motion <= 11'd0;
				Log_X_Motion <= 11'd0;
				Log_X_Pos <= Log_X_Start;
				Log_Y_Pos <= Log_Y_Start;
        end
           
        else 
        begin 
				 if ( (Frog_Y_Pos + Frog_Size) >= Frog_Y_Max )  // frog is at the bottom edge
				 begin
					  Frog_Y_Motion <= (~ (Frog_Y_Step) + 1'b1);  // 2's complement.	
					  //Frog_Y_Motion <= 10'd0;
					  Frog_X_Motion <= 11'd0; //No Diagonal
				 end
				 else if ( (Frog_Y_Pos - Frog_Size) <= Frog_Y_Min )  // frog is at the top edge
				 begin
					  Frog_Y_Motion <= Frog_Y_Step;
					  //Frog_Y_Motion <= 10'd0;
					  Frog_X_Motion <= 11'd0;  //No Diagonal
				 end	  
				 else if ( (Frog_X_Pos + Frog_Size) >= Frog_X_Max )  // frog is at the right edge
				 begin
					  Frog_X_Motion <= (~ (Frog_X_Step) + 1'b1);		//2's complement. 
					  //Frog_X_Motion <= 10'd0;
					  Frog_Y_Motion <= 11'd0;  //No Diagonal
				 end
				 else if ( (Frog_X_Pos - Frog_Size) <= Frog_X_Min )  // frogis at the left edge
				 begin
					  Frog_X_Motion <= Frog_X_Step; 	
					  //Frog_X_Motion <= 10'd0;  
					  Frog_Y_Motion <= 11'd0;  //No Diagonal
				 end 
				 
				 //Log movement restriction code
				 else if ( (Log_X_Pos + Log_X_Size) >= Frog_X_Max )
				 begin
					  Log_X_Motion  <= 11'd0;
				 end
				 
				 else if ( (Log_X_Pos - Log_X_Size) <= Frog_X_Min )
				 begin
					  Log_X_Motion  <= 11'd0;
				 end
				 
				 else 
					  
					  begin
					  if(keycode == 8'b01010000) // left 	0x04
						  begin
								Frog_X_Motion <= (~ (Frog_X_Step) + 1'b1);
								Frog_Y_Motion <= 11'd0;
						  end
				     else if (keycode == 8'b01010010) // up 	0x1A
						  begin
								Frog_Y_Motion <= (~ (Frog_Y_Step) + 1'b1);
								Frog_X_Motion <= 11'd0;
						  end
				     else if (keycode == 8'b01001111) // right 	0x07
						  begin
								Frog_X_Motion <= Frog_X_Step;
								Frog_Y_Motion <= 11'd0;	
							end
				     else if (keycode == 8'b01010001) // down  0x16
						  begin
								Frog_Y_Motion <= Frog_Y_Step; 
								Frog_X_Motion <= 11'd0;
							end
					  //When log should move, should always be moving
					  else if (keycode >= 8'b00000000)
						  begin
								Log_X_Motion <= Log_X_Step;
						  end
						  
					  else
						  begin
								Frog_Y_Motion <= 11'd0; 
								Frog_X_Motion <= 11'd0;
								Log_X_Motion <= 11'd0;
						  end
					  end   
					  				 
				Frog_Y_Pos <= (Frog_Y_Pos + Frog_Y_Motion);  // Update frog position
				Frog_X_Pos <= (Frog_X_Pos + Frog_X_Motion);
				Log_X_Pos <= (Log_X_Pos + Log_X_Motion);
				Log_Y_Pos <= 11'd0;
			
        end  
    end
       
    assign FrogX = Frog_X_Pos;
   
    assign FrogY = Frog_Y_Pos;
   
    assign FrogS = Frog_Size;
	 
	 assign LogX = Log_X_Pos;
	 
	 assign LogY = Log_Y_Pos;
    

endmodule


