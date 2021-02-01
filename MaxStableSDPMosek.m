clear
clc
ne=[150;200;250;300];
pe=[3;8];
l=1;
for i=4:4
    for j=2:2
        n=ne(i);
        nsym=0.5*n*(n+1);
        p=pe(j);
        dataname=strcat('p.',num2str(p),'n',num2str(n),'.txt');
        J=ones(n);
        DNNproblem.C=-J;
        DNNproblem.A=importdata(dataname)+eye(n);
        DNNproblem.b=1;
        m=1;
        for q=1:l
            datetime
            strcat('counting_p.',num2str(p),'n',num2str(n),'_SDP_',num2str(q),'/2')
            tic;
            prob=MaxStableSetmosekSDPformulation(n,m,DNNproblem);
            %param.MSK_DPAR_OPTIMIZER_MAX_TIME = 20000;
            formulationtime(q)=toc;
            [r,res]=mosekopt('minimize echo(0) info symbcon',prob)%,param);
%             if j==1
%                 [r,res]=mosekopt('minimize echo(0) info symbcon log(111.txt)',prob,param);%
%             elseif j==2
%                 [r,res]=mosekopt('minimize echo(0) info symbcon log(222.txt)',prob,param);%
%             end
            time(q)=toc;
            solvertime(q)=res.info.MSK_DINF_OPTIMIZER_TIME;
        end
        result.obj=-res.sol.itr.pobjval;
        result.r=r;
        result.solvertime=mean(solvertime);
        result.cputime=mean(time);
        result.formulationtime=mean(formulationtime);
        name=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SDPmosek_square_11.3.mat');
        save(name,'result');
    end
end