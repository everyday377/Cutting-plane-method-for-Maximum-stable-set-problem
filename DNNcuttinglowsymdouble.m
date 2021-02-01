function result=DNNcuttinglowsymdouble(model,params,n,cuttime)

tic;
%setting up for the initial lower bound
nsym=n*(n+1)*0.5;

result1 = gurobi(model, params);
time(1)=toc;
runtimel(1)=result1.runtime;
xl= result1.x;
fl(1)= result1.objval;
clear result1
count=2;
while time(count-1)<cuttime
    Xl=vec2symdouble(xl,n);
    [P,~]=eigs(Xl,2,'smallestreal');
    pm=zeros(nsym,2);
    for i=1:2
        pm(:,i)=sym2vecdouble(P(:,i)*transpose(P(:,i)),n);
    end
    scale=max(max(abs(pm)));
    pm=pm/scale;
    for ii=1:nsym
        for jj=1:2
            if abs(pm(ii,jj))<10^-2
                pm(ii,jj)=0;
            end
        end
    end
    pm=sparse(pm);
    model.rhs=[zeros(2,1);model.rhs];
    model.A=[-transpose(pm);model.A];
    model.sense = [repmat('<', 2, 1);model.sense];
    result1 = gurobi(model, params);
    time(count)=toc;
    
    runtimel(count)=result1.runtime;
    xl= result1.x;
    fl(count)= result1.objval;
    count=1+count;
    clear result1
end

result.fl=fl;
result.cputime=time;
result.runtimel=runtimel;