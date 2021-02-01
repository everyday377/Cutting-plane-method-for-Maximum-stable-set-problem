function prob=mosekDNNSOCPformulation(n,m,vecC,A,b)%A=[vecA1^T;vecA2^T;...]

clear prob;

[r, res] = mosekopt('symbcon');
% Specify the non-conic part of the problem.


prob.c   = [vecC;sparse(n*(n-1),1)];

prob.a=[A sparse(m,n*(n-1));sparse(n*(n-1),0.5*n*(n+1)) -sparse(1:n*(n-1),1:n*(n-1),ones(1,n*(n-1)))];

count=0;
for i=1:n-1
    for j=i+1:n
        prob.a(m+2*count+1,0.5*i*(i+1))=1;
        prob.a(m+2*count+2,0.5*j*(j+1))=1;
        count=count+1;
    end
end

b=[b;sparse(n*(n-1),1)];

prob.blc = b;
prob.buc = b;
prob.blx = zeros(0.5*n*(n+1)+n*(n-1),1);
prob.bux = inf*ones(0.5*n*(n+1)+n*(n-1),1);

prob.cones.type   = ones(1,0.5*n*(n-1))*res.symbcon.MSK_CT_RQUAD;
prob.cones.sub    = [];
count=0;
for i=1:n-1
    for j=i+1:n
        prob.cones.sub=[prob.cones.sub 0.5*n*(n+1)+2*count+1 0.5*n*(n+1)+2*count+2 0.5*j*(j-1)+i];
        count=count+1;
    end
end

prob.cones.subptr =1:3:-2+0.5*n*(n-1)*3;
end