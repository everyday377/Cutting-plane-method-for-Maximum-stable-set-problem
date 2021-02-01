clear
clc
ne=[50;100;150];
me=[10;50];
delta=10^-6;
cuttime=80;
l=5;
eps=10^-3;
for i=2:2
    for j=1:1
        for k=2:2
            n=ne(i);
            nsym=0.5*n*(n+1);
            m=me(j);
            DNNproblem=importdata(strcat(num2str(n),'_',num2str(m),'_DNN',num2str(k),'.mat'));
            C=sym2vecdouble(DNNproblem.C,n);
            b=transpose(DNNproblem.b);
            A=transpose(sym2vecdouble(DNNproblem.A(1).A,n));
            for p=2:m
                A=[A;transpose(sym2vecdouble(DNNproblem.A(p).A,n))];
            end
            time0=cputime;
            prob=mosekDNNSOCPformulation(n,m,C,A,b);
            formulationtime=cputime-time0;
            for ll=1:2
                if ll==1
                    for kk=1:l
                    result=mosekQCP(prob,n,m,delta,cuttime);
                    time(kk,:)=result.cputime;
                    end
                elseif ll==2
                    for kk=1:l
                    result=mosekQCP_SOCPcut(prob,n,m,delta,cuttime,eps);
                    time(kk,:)=result.cputime;
                    end
                end
                
            result.formulationtime=formulationtime;
            result.fl=-result.fl;
            result.cputime=[];
            result.cputime=mean(time);
            result.totaltime=result.cputime(end);
            
                if ll==1
                    name=strcat('result_',num2str(n),'_',num2str(m),'_DNN',num2str(k),'_SOCPmosek_8.22.mat');
                elseif ll==2
                    name=strcat('result_',num2str(n),'_',num2str(m),'_DNN',num2str(k),'_SOCPmosek_SOCPcut_9.4.mat');
                end
            save(name,'result');
            
            end
            
                
        end
    end
end

