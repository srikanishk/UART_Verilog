//UART Project

//UART transmitter
module UART_transmitter(clk,start,in,stop,t_active,out,t_done);
  
  input clk,start,stop;
  input [7:0] in;
  
  output reg out,t_active=0,t_done=0;

  parameter S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
    //clock cycles per bit
  integer cpb=26; //By changing cpb we can vary baud rate

  reg [1:0] state=S0; 
  
  reg [7:0] data,clk_count=0,i=0;
  
  always @(posedge clk) 
   begin
    case(state)
      S0 : begin
           out=1;
           t_done=0;
           if(start==0)
              begin
                t_active= 1'b1;
                data<=in;
                state=S1;
              end
            else
            state=S0;
           end
      
      S1 : begin
          out<=0; //transmit start bit
        if(clk_count<cpb-1)
             begin 
                clk_count<=clk_count+1;
                state=S1;
              end
           else
             begin
              state=S2;
              clk_count=0;
             end
         end
      
      S2 : begin
           out<=data[i];
        if(clk_count<cpb-1)
           begin
            clk_count<=clk_count+1;
            state=S2;
           end
         else
          begin
            clk_count=0;
            if(i<7)
              begin
                state=S2;
                i<=i+1;
              end
            else
             begin i=0;
              state=S3;
             end
           end
       end
        
       S3 : begin
          out<=1; //transmit stop bit
         if(clk_count<cpb-1)
             begin 
                clk_count<=clk_count+1;
                state=S3;
              end
           else
             begin
              state=S0;
              clk_count=0;
              t_done=1;
              cpb<=cpb*2;
             end
         
         end 
      
       endcase
     
      end
              
 endmodule

//UART Receiver
module UART_receiver(I,clk,O,r_done);
  
  input I,clk;
  
  output reg [7:0] O;
  output reg r_done=0;
  
  parameter S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
    
  reg [1:0] state=S0;
  
  integer cpb=26;
  
  reg [7:0] clk_count=0,i=0;

  always @(posedge clk)
   begin
     case(state)
      S0: begin
        if(I==0) state=S1;
           else state=S0;
           r_done=0;
           end
       
     S1:  begin                           //wait out start bit
          if(clk_count<cpb-1)
             begin 
                clk_count<=clk_count+1;
                state=S1;
              end
           else
             begin
              state=S2;
              clk_count=0;
             end
          end 
       
       S2: begin            //Start receiving bits
            if(clk_count<cpb-1)
              begin
                clk_count<=clk_count+1;
                state=S2;
                O[i]=I;
              end
            else
             begin
              clk_count=0;
              if(i<7)
                begin
                 state=S2;
                 i<=i+1;
                end
               else
                 begin 
                  i=0;
                  state=S3;
                  r_done=1;
                 end
             end
          end 
       
       S3: begin       //wait out stop bit
           if(I==1)
           begin
              if(clk_count<cpb-1)
               begin 
                clk_count<=clk_count+1;
                state=S3;
               end
             else
               begin
                state=S0;
                clk_count=0;
                cpb<=cpb*2;
               end
           end
         end
      endcase
   end
endmodule 