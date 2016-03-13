function decod_frame = I_decoder(frame, quality)

cod_frame = frame.coded;

% Blocks 8x8 IDCT
[m,n] = size(cod_frame);
indj = [8*(0:(m)/8-1)+1, m+1];
indk = [8*(0:(n)/8-1)+1, n+1];

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

decod_frame = zeros(m,n);

for j = 1:length(indj)-1     
    for k = 1:length(indk)-1
        cod_blocks = cod_frame(indj(j):indj(j+1)-1,indk(k):indk(k+1)-1);
        decod = cod_blocks.*Q;
        decod_frame(indj(j):indj(j+1)-1,indk(k):indk(k+1)-1) = idct2(decod);
       % imshow(decod_frame);
    end
end
decod_frame = decod_frame./255;


end
