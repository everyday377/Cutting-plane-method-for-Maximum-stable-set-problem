clear
clc
nvector=[10;50;100;150;200];
for e=5:5
n=nvector(e);
nsym=0.5*n*(n+1);
% Add rotated cone: x^2 <= yz
count=1;
for i=1:n
    for j=i:n
        if i<j     
            Q=sparse(nsym,nsym);
            Q(0.5*(j-1)*j+i,0.5*(j-1)*j+i)=1;
            Q(0.5*(i+1)*i,0.5*(j+1)*j)=-1;
            model.quadcon(count).Qc = Q;
            model.quadcon(count).q  = zeros(nsym,1);
            model.quadcon(count).rhs = 0;
            count=count+1;
        end
    end
end
model.quadcount=count-1;
name=string(strcat('SOCPmodel_',num2str(n),'.mat'));
save(name,'model');
end