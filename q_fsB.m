function [Q] = q_fsB(x,y)

x = double(x);
y = double(y);

[M,N] = size(x);

blockSize = 8;
tmpI = 1:blockSize:M;
tmpJ = 1:blockSize:N;
Q = zeros(length(tmpI),length(tmpJ));

for ti=1:length(tmpI)
    for tj=1:length(tmpJ)
        i = tmpI(ti);
        j = tmpJ(tj);
        iend = min( (i+blockSize-1) , M );
        jend = min( (j+blockSize-1) , N );
        blockX = x(i:iend,j:jend);
        blockY = y(i:iend,j:jend);
        
        Nb = length(blockX(:));

        mx = mean(blockX(:));
        my = mean(blockY(:));

        sx2 = var(blockX(:));
        sy2 = var(blockY(:));

        tmp = ( blockX(:) - repmat(mx,Nb,1) ) .* ( blockY(:) - repmat(my,Nb,1) );
        sxy = 1/Nb * sum( tmp );

        Q(ti,tj) = 4 * sxy * mx * my / ( (sx2 + sy2) * (mx.^2 + my.^2) );
    end
end

Q = mean(Q(~isnan(Q))); %% isnan prevents from a block being constant and having 0 variance

end