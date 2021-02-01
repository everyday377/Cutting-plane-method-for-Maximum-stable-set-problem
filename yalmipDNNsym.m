function [opt,solvertime,yalmiptime]=yalmipDNNsym(n,m,DNNproblem)
nsym=0.5*n*(n-1);
C=[DNNproblem.C sparse(n,nsym);sparse(nsym,n) sparse(nsym,nsym)];
P1 = sdpvar(n,n);
for i=2:n
    a([0.5*(i-1)*(i-2)+1:0.5*(i-1)*i])=P1([1:i-1],i);
end
P2=diag(a);
P=[P1 sparse(n,nsym);sparse(nsym,n) P2];
objective=trace(transpose(C)*P);
F = [P>=0];
for i=1:m
    A=[DNNproblem.A(i).A sparse(n,nsym);sparse(nsym,n) sparse(nsym,nsym)];
    F=[F,trace(transpose(A)*P)==DNNproblem.b(i)];
end
result=optimize(F,objective);
opt=value(objective);
solvertime=result.solvertime;
yalmiptime=result.yalmiptime;