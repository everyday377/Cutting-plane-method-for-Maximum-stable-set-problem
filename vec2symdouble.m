function A=vec2symdouble(a,n)% transform a vector which contains the upper n(n+1)/2 triangle components into a symmetric matrix 

A=zeros(n,n);
for i=1:n
    A(1:i,i)=sqrt(0.5)*a(0.5*(i-1)*i+1:0.5*i*(i+1));
    A(i,1:i)=sqrt(0.5)*a(0.5*(i-1)*i+1:0.5*i*(i+1));
    A(i,i)=a(0.5*i*(i+1));
end
A=sparse(A);