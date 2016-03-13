function decod_frame = P_decoder(P, I, quality)

mv = P.motionVector;
error = P.predError;


Q = [16 17 18 19 20 21 22 23;
     17 18 19 20 21 22 23 24;
     18 19 20 21 22 23 24 25;
     19 20 21 22 23 24 26 27;
     20 21 22 23 25 26 27 28;
     21 22 23 24 26 27 28 30;
     22 23 24 26 27 28 30 31;
     23 24 25 27 28 30 31 33];
 Q = Q*quality;

for i = 1:size(error,3)
    pe_dct(1:8,1:8,i) = idct2(error(1:8,1:8,i).*Q);
    pe_dct(1:8,9:16,i) = idct2(error(1:8,9:16,i).*Q);
    pe_dct(9:16,1:8,i) = idct2(error(9:16,1:8,i).*Q);
    pe_dct(9:16,9:16,i) = idct2(error(9:16,9:16,i).*Q);
end

[x,y] = size(I);
sweepX = [16*(0:(x)/16-1)+1, x+1];
sweepY = [16*(0:(y)/16-1)+1, y+1];
block = 1;

for j = 1:length(sweepX)-1     
    for k = 1:length(sweepY)-1
        
        dX = mv(block,1);
        dY = mv(block,2);
        
        I_block = I(sweepX(j)+dX:sweepX(j+1)-1+dX,sweepY(k)+dY:sweepY(k+1)-1+dY);
        decod_frame(sweepX(j):sweepX(j+1)-1,sweepY(k):sweepY(k+1)-1) = I_block + pe_dct(:,:,block);

        block = block + 1;
    end
end 

end
