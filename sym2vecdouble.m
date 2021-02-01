function a=sym2vecdouble(A,n)% transform symmetric matrix into a vector which contains the upper n(n+1)/2 triangle components 
a=zeros(0.5*n*(n+1),1);
for i=1:n
    a(0.5*(i-1)*i+1:0.5*i*(i+1))=sqrt(2)*A(1:i,i);
    a(0.5*i*(i+1))=A(i,i);
end
a=sparse(a);