clear
clc
ne=[150;200;250;300];
pe=[3;8];
l=1;
for i=1:4
    for j=1:2
        n=ne(i);
        nsym=0.5*n*(n+1);
        p=pe(j);
        dataname=strcat('p.',num2str(p),'n',num2str(n),'.txt');
        J=ones(n);
        DNNproblem.C=-J;
        DNNproblem.A(1).A=importdata(dataname)+eye(n);
        DNNproblem.b=1;
        m=1;
            for q=1:l
                tic;
                [result.obj,solvertime(q),result.info,result.runhist]=sdptsolver(n,m,DNNproblem);
                time(q)=toc;
            end
            result.solvertime=mean(solvertime);
            result.cputime=mean(time);
            name=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SDPT3_10.30.mat');
            save(name,'result');
    end
end