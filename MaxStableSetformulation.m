clear
clc
n=150;
p=3;
dataname=strcat('p.',num2str(p),'n',num2str(n),'.txt');
A1=importdata(dataname);
J=ones(n);
A2=A1+eye(n);
C=sym2vec(J,n);
A=transpose(sym2vec(A2,n));
b=1;
k=80;%(k is the limit iteration)
delta=10^-6;% delta is the stopping cretieria
result=DNNcuttinglowsym(C,b,A,n,m,vec,delta,k);