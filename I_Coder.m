function cod_frame = I_Coder(frame, quality)

% Blocks 8x8 & DCT
[m,n] = size(frame);
sweepX = [8*(0:(m)/8-1)+1, m+1];
sweepY = [8*(0:(n)/8-1)+1, n+1];

% Matrix
Q = [8 16 19 22 26 27 29 34;
    16 16 22 24 27 29 34 37;
    19 22 26 27 29 34 34 38;
    22 22 26 27 29 34 37 40;
    22 26 27 29 32 35 40 48;
    26 27 29 32 35 40 48 58;
    26 27 29 34 38 46 56 69;
    27 29 35 38 46 56 69 83];

Q = Q*quality;
        

frame = frame.*255;

for j = 1:length(sweepX)-1     
    for k = 1:length(sweepY)-1
        blocks = frame(sweepX(j):sweepX(j+1)-1,sweepY(k):sweepY(k+1)-1);
        dct = dct2(blocks);
        cod_frame(sweepX(j):sweepX(j+1)-1,sweepY(k):sweepY(k+1)-1) = round(dct./Q);
    end
end

end
