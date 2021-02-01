clear
clc
ne=[10;50;100];
me=[10;50;100];
l=3;% number of experiments
for i=1:3
    if i==1
        kk=2;
    else
        kk=3;
    end
    for j=1:kk
        for k=1:3
            n=ne(i);
            m=me(j);
            DNNproblem=importdata(strcat(num2str(n),'_',num2str(m),'_DNN',num2str(k),'.mat'));
            for q=1:l
                tt=cputime;
                [result.obj,solvertime(q)]=sdptsolver(n,m,DNNproblem);
                time(q)=cputime-tt;
            end
            result.solvertime=mean(solvertime);
            result.cputime=mean(time);
            name=strcat(num2str(n),'_',num2str(m),'_DNN',num2str(k),'_resultSDPTsym_2.4.mat');
            save(name,'result');
        end
    end
end