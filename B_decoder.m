function decod_frame = B_decoder(frame3, frame1, frame2, quality)

mv1 = frame3.motionVector1;
mv2 = frame3.motionVector2;
pe_dct = frame3.predError;
decod_frame = zeros(size(frame1));

% IDCT prediction error
Q = [16 17 18 19 20 21 22 23;
     17 18 19 20 21 22 23 24;
     18 19 20 21 22 23 24 25;
     19 20 21 22 23 24 26 27;
     20 21 22 23 25 26 27 28;
     21 22 23 24 26 27 28 30;
     22 23 24 26 27 28 30 31;
     23 24 25 27 28 30 31 33];
Q = Q*quality;

for i = 1:size(pe_dct,3)
    pe(1:8,1:8,i) = idct2(pe_dct(1:8,1:8,i).*Q);
    pe(1:8,9:16,i) = idct2(pe_dct(1:8,9:16,i).*Q);
    pe(9:16,1:8,i) = idct2(pe_dct(9:16,1:8,i).*Q);
    pe(9:16,9:16,i) = idct2(pe_dct(9:16,9:16,i).*Q);
end

% Block matching inverse 16x16
[m,n] = size(frame1);
indj = [16*(0:(m)/16-1)+1, m+1];
indk = [16*(0:(n)/16-1)+1, n+1];
block = 1;
for j = 1:length(indj) - 1
    for k = 1:length(indk)-1
        move1 = mv1(block,:);
        move2 = mv2(block,:);
        block1 = frame1(indj(j)+ move1(1):indj(j+1)-1+move1(1),indk(k)+move1(2):indk(k+1)-1+move1(2));
        block2 = frame2(indj(j)+ move2(1):indj(j+1)-1+move2(1),indk(k)+move2(2):indk(k+1)-1+move2(2));
        decod_frame(indj(j):indj(j+1)-1,indk(k):indk(k+1)-1) = 0.5.*(block1 + block2) + pe(:,:,block);
        
        block = block + 1;
    end
end


end