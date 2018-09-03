//clf;
clc;
clear all;


load('TDT40kHorScanData.dat');
    Pos = 3;
    N = 12
    num = 1:32;
    k =1;
    for Ch =1+ (32*Pos):32+ (32*Pos) 
    y = data(Ch,1000-23:2000);
 

  //  start = 1050;
  //  stop = start +640-1;    
   // y = y(start:stop);
    y = y./max(abs(y));
    y = 2^N + y*2^(N);
    y = int(y)
    //y = [y 2^(N+2)*ones(1,48)];
    z = dec2bin(y,16);

    str = 'chan_' + string(num(k)) + '.txt';
    k = k+1;
    csvWrite(z', str);
   end  
           clear data;





