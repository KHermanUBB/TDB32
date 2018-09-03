//clf;
clc;
clear all;


    Pos = 44;
    N = 12
    num = 1:32;
    k =1;
    y = 0:2047;
    z = dec2bin(y,16);
    for Ch =1+ (32*Pos):32+ (32*Pos) 
    str = 'chan_' + string(num(k)) + '.txt';
    k = k+1;
    csvWrite(z', str);
   end  
           clear data;





