function [mv,pe_dct] = P_Coder(P,I,quality)

%Declaraciones
[x,y] = size(P);
sweepX= [16*(0:(x)/16-1)+1,x+1]; %Index flor blocks (16x16)
sweepY= [16*(0:(y)/16-1)+1,y+1];
%Inicialización
block=1;
prevQ=0;
lookWin=8; %Mitad del bloque
pe_dct=zeros(16,16);

for i = 1:length(sweepX)-1
    for j = 1:length(sweepY)-1
        %Declaraciones
        block_P= P(sweepX(i):sweepX(i+1)-1,sweepY(j):sweepY(j+1)-1);         
        maxLim=0;
        minLim = 0;
        %Comprobación en filas. Componente X
        if i==1 
            maxLim = lookWin;
        end
        
        
        if i == length(sweepX)-1
            minLim = lookWin -(sweepX(i+1)-1 - x) ;
        end
        
        %Comprobación en columnas. Componente y 
        upperLim=0;
        bottomLim=0;
        
        if j == 1
            upperLim=lookWin;
        end
        
        if j == length(sweepY)-1
            bottomLim = lookWin - (sweepY(j+1)-1-y);
        end
        
         for dX = (-lookWin+maxLim):(lookWin-minLim)
            for dY = (-lookWin+upperLim):(lookWin-bottomLim)

            block_I = I(sweepX(i)+dX:sweepX(i+1)-1+dX,sweepY(j)+dY:sweepY(j+1)-1+dY);
            Q = q_fsB(block_P,block_I);

                
                if Q > prevQ
                    mv(block,:) = [dX,dY];
                    error(:,:,block) = block_P - block_I;
                end
                prevQ = Q;
            end
        end
         
         block= block+1;
       end
end
     

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
        pe_dct(1:8,1:8,i) = round((dct2(error(1:8,1:8,i)))./Q);
        pe_dct(1:8,9:16,i) = round((dct2(error(1:8,9:16,i)))./Q);
        pe_dct(9:16,1:8,i) = round((dct2(error(9:16,1:8,i)))./Q);
        pe_dct(9:16,9:16,i) = round((dct2(error(9:16,9:16,i)))./Q);
    end 


end
