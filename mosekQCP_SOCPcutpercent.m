
function result=mosekQCP_SOCPcutpercent(prob,n,m,cuttime,percent)%A=[vecA1^T;vecA2^T;...]
tic;
nnn=n*percent;
if percent==2
    nn=2;
else
    nn=ceil(0.5*(1+sqrt(1+8*nnn)));
end
nsym=0.5*n*(n+1);
%setting up for the initial lower bound
[r(1),res]=mosekopt('minimize echo(0) info symbcon',prob);
time(1)=toc;
fl(1)=res.sol.itr.pobjval;
runtimel(1)=res.info.MSK_DINF_OPTIMIZER_TIME;
xl=res.sol.itr.xx(1:0.5*n*(n+1));
count=2;
while time(count-1)<cuttime
    Xl=vec2symdouble(xl,n);
    [P,~]=eigs(Xl,nn,'smallestreal');
    for i=1:nn-1
        for j=i+1:nn
            pm=zeros(nsym,3);
            pm(:,1)=sym2vecdouble(P(:,i)*transpose(P(:,i)),n);
            pm(:,2)=sym2vecdouble(P(:,j)*transpose(P(:,j)),n);
            pm(:,3)=sqrt(2)*sym2vecdouble(0.5*P(:,i)*transpose(P(:,j))+0.5*P(:,j)*transpose(P(:,i)),n);
            scale=max(max(abs(pm)));
            pm=pm/scale;
            for ii=1:nsym
                for jj=1:3
                    if abs(pm(ii,jj))<10^-2
                        pm(ii,jj)=0;
                    end
                end
            end
            pm=sparse(pm);
            
            prob.c=[prob.c;sparse(3,1)];
            prob.blc=[prob.blc;sparse(3,1)];
            prob.buc=[prob.buc;sparse(3,1)];
            prob.blx=[prob.blx;sparse(2,1);-inf];
            prob.bux=[prob.bux;inf*ones(3,1)];
            if and(count==2,and(i==1,j==2))
                v=[];
            else
                v=[v sparse(3,3)];
            end
            prob.a=[prob.a;transpose(pm) sparse(3,n*(n-1)) v];
            prob.a=[prob.a [sparse(m+n*(n-1),3);transpose(v);-eye(3)]];
            prob.cones.type   = [prob.cones.type res.symbcon.MSK_CT_RQUAD];
            prob.cones.sub=[prob.cones.sub size(prob.c,1)-2 size(prob.c,1)-1 size(prob.c,1)];
            prob.cones.subptr =[ prob.cones.subptr prob.cones.subptr(end)+3];
        end
    end
    [r(count),res]=mosekopt('minimize echo(0) info symbcon',prob);
    time(count)=toc;
    fl(count)=res.sol.itr.pobjval;
    runtimel(count)=res.info.MSK_DINF_OPTIMIZER_TIME;
    xl=res.sol.itr.xx([1:0.5*n*(n+1)]);
    count=1+count;
    
end

result.fl=fl;
result.cputime=time;
result.exitflagl=r;
result.runtimel=runtimel;