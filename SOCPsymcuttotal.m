clear
clc
ne=[10;50;100;150;200];
me=[10;50;100];
delta=10^-6;
cuttime=80;
l=3;
for i=2:2
    for j=1:1
        for k=1:1
        %% Data import
            n=ne(i);
            nsym=0.5*n*(n+1);
            m=me(j);
        model=load(strcat('SOCPmodel_',num2str(n),'.mat'));
        model=model.model;
        DNNproblem=importdata(strcat(num2str(n),'_',num2str(m),'_DNN',num2str(k),'.mat'));
        C=sym2vecdouble(DNNproblem.C,n);
        b=transpose(DNNproblem.b);
        A=transpose(sym2vecdouble(DNNproblem.A(1).A,n));
        for p=2:m
           A=[A;transpose(sym2vecdouble(DNNproblem.A(p).A,n))];
        end
        model.obj = C;%c^Tx
        model.modelsense = 'min';
        model.A=sparse(A);%Ax=b
        model.rhs=b;%Ax=b
        model.sense =repmat('=',m,1);%Ax=b
        model.lb =zeros(nsym,1);% x_i>=0
        %% Cutting algorithm process
   
            time=[];
            for kk=1:l
                result=SOCPsymcut(n,m,model,delta,cuttime);
                time(kk,:)=result.cputime;
            end
            result.fl=result.fl;
            result.cputime=[];
            result.cputime=mean(time);
            result.totaltime=result.cputime(end);
            name=strcat('result_',num2str(n),'_',num2str(m),'_DNN',num2str(k),'_SOCPsym_7.10.mat');
            save(name,'result');
        end
    end
end