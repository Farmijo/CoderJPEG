function [roe]=MSE(x,y)

Dim=size(x);
roe=0;
for i=1:length(x(:,1))
   for j=1:length(x(1,:))
       val=(x(i,j)-y(i,j))^2;
       roe=roe+val;
   end
end
    roe=roe/(Dim(1)*Dim(2));

end