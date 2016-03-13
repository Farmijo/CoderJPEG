function [y]=PSNR(x,y)
mse=PSNR(x,y);
y=10*log((max(max(x)))^2/mse);

end