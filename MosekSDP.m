clear
clc
ne=[10;50;100;150];
me=[10;50];
l=1;
for i=1:1
    for j=1:1
        for k=1:1
            n=ne(i);
            m=me(j);
            DNNproblem=importdata(strcat(num2str(n),'_',num2str(m),'_DNN',num2str(k),'.mat'));
            for q=1:l
                tt=cputime;
                prob=mosekDNNSDPformulationsquare(n,m,DNNproblem);
                formulationtime(q)=cputime-tt;
                [r,res]=mosekopt('minimize echo(0) info symbcon',prob);
                time(q)=cputime-tt;
                solvertime(q)=res.info.MSK_DINF_OPTIMIZER_TIME;
            end
            result.obj=res.sol.itr.pobjval;
            result.r=r;
            result.solvertime=mean(solvertime);
            result.cputime=mean(time);
            result.formulationtime=mean(formulationtime);
            name=strcat(num2str(n),'_',num2str(m),'_DNN',num2str(k),'_resultMosek_9.4.mat');
            save(name,'result');
        end
    end
end


