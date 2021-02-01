function result=SOCPsymcut(n,m,model,delta,k)
nsym=n*(n+1)*0.5;
time0=cputime;
[xl,fl(1),exitflagl(1),runtimel(1)]=SOCP(nsym,model);%%initial lower bound outer approximation
time(1)=cputime-time0;
count=2;
exitflag=0;
while exitflag==0
    Xl=vec2symdouble(xl,n);
    [P,D]=eig(Xl);
    D1=diag(D); 
    [~,II]=sort(D1);
    pm=zeros(nsym,2);
    for i=1:2
    pm(:,i)=sym2vecdouble(P(:,II(i))*transpose(P(:,II(i))),n);
    end
    model.A=[model.A;transpose(pm)];
    model.rhs=[model.rhs;0;0];%Ax=b
    model.sense =[model.sense; repmat('>',2,1)]; 
    [xl,fl(count),exitflagl(count),runtimel(count)] = SOCP(nsym,model);
    time(count)=cputime-time0;
    count=1+count;
    if count>k
        exitflag=2;
    elseif min(diag(D))>-delta
        exitflag=1;
    end
end

result.fl=fl;
result.cputime=time;
result.exitflag=exitflag;
result.exitflagl=exitflagl;
result.runtimel=runtimel;