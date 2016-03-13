function [motion1, motion2, error] = B_coder(frame, I, P, quality)

%Declaraciones
[x,y] = size(frame);
sweepX= [16*(0:(x)/16-1)+1,x+1]; %Index flor blocks (16x16)
sweepY= [16*(0:(y)/16-1)+1,y+1];
%Inicialización
block=1;
prevQ=0;
lookWin=8; %Mitad del bloque
b1=[];
b2=[];


for i = 1:length(sweepX)-1     
    for j = 1:length(sweepY)-1
        blockFrame = frame(sweepX(i):sweepX(i+1)-1,sweepY(j):sweepY(j+1)-1);        
        
        maxLim = 0;
        if i == 1
            maxLim = lookWin;
        end
              
        minLim = 0;
        if i == length(sweepX)-1
            minLim = lookWin -(sweepX(i+1)-1 - x) ;
        end
 
        upperLim = 0;
        if j == 1
            upperLim = lookWin;
        end
              
        bottomLim = 0;
        if j == length(sweepY)-1
            bottomLim = lookWin -(sweepY(j+1)-1 - y) ;
        end          
        
        for dX = (-lookWin+maxLim):(lookWin-minLim)
            for dY = (-lookWin+upperLim):(lookWin-bottomLim)

            block_I = I(sweepX(i)+dX:sweepX(i+1)-1+dX,sweepY(j)+dY:sweepY(j+1)-1+dY);
            Q = q_fsB(blockFrame,block_I);
                
                if Q > prevQ
                    motion1(block,:) = [dX,dY];
                    b1(:,:,block) = blockFrame;
                    b2(:,:,block) = block_I;
                end
                prevQ = Q;
            end
        end
        block = block + 1;
    end
end 



% Next Anchor
[x,y] = size(frame);
sweepX = [16*(0:(x)/16-1)+1, x+1];
sweepY = [16*(0:(y)/16-1)+1, y+1];
block = 1;
prevQ = 0;
lookWin = 8;

for i = 1:length(sweepX)-1     
    for j = 1:length(sweepY)-1
        blockFrame = frame(sweepX(i):sweepX(i+1)-1,sweepY(j):sweepY(j+1)-1);        
        
        maxLim = 0;
        if i == 1
            maxLim = lookWin;
        end
              
        minLim = 0;
        if i == length(sweepX)-1
            minLim = lookWin -(sweepX(i+1)-1 - x) ;
        end

        upperLim = 0;
        if j == 1
            upperLim = lookWin;
        end
              
        bottomLim = 0;
        if j == length(sweepY)-1
            bottomLim = lookWin -(sweepY(j+1)-1 - y) ;
        end          
        
        for dj = (-lookWin+maxLim):(lookWin-minLim)
            for dk = (-lookWin+upperLim):(lookWin-bottomLim)

            block_P = P(sweepX(i)+dj:sweepX(i+1)-1+dj,sweepY(j)+dk:sweepY(j+1)-1+dk);
            Q = q_fsB(blockFrame,block_P);

                
                if Q > prevQ
                    motion2(block,:) = [dj,dk];
                    b3(:,:,block) = block_P;
                end
                prevQ = Q;
            end
        end
        block = block + 1;
    end
end 
b3=double(b3);
predError = b1 - 0.5.*(b2+b3);

Q = [16 17 18 19 20 21 22 23;
     17 18 19 20 21 22 23 24;
     18 19 20 21 22 23 24 25;
     19 20 21 22 23 24 26 27;
     20 21 22 23 25 26 27 28;
     21 22 23 24 26 27 28 30;
     22 23 24 26 27 28 30 31;
     23 24 25 27 28 30 31 33];
 
Q = Q*quality;

for i = 1:block-1
    error(1:8,1:8,i) = round((dct2(predError(1:8,1:8,i)))./Q);
    error(1:8,9:16,i) = round((dct2(predError(1:8,9:16,i)))./Q);
    error(9:16,1:8,i) = round((dct2(predError(9:16,1:8,i)))./Q);
    error(9:16,9:16,i) = round((dct2(predError(9:16,9:16,i)))./Q);
end

end


