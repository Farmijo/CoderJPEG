

Q_mean = 0;
for i = 1:(num_frames-2)
    Q = q_fsB(frames(:,:,i),decod_frames(:,:,i));
    Q_mean = Q_mean + Q;
end

Q_mean = Q_mean/(num_frames-2);

MSE_mean = 0;
for k = 1:(num_frames-2)
    x=frames(:,:,k);    
    y=decod_frames(:,:,k);
    MSE_1 = MSE(x,y);
    MSE_mean = MSE_mean + MSE1;
end

MSE_mean = MSE_mean/(num_frames-2);

PSNR_mean = 0;
for i = 1:(num_frames-2)
    PSNR1 = PSNR(frames(:,:,i),decod_frames(:,:,i));
    PSNR_mean = PSNR_mean + PSNR1;
end

PSNR_mean = PSNR_mean/(num_frames-2);




