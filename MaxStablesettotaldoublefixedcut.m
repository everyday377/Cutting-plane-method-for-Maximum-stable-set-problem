clear
clc
ne=[150;200;250;300];
pe=[3;8];
cuttime=600;%set the maximum calculation time(s)
l=3;
key=2;
for i=1:1
    for j=1:1
        n=ne(i);
        nsym=0.5*n*(n+1);
        p=pe(j);
        dataname=strcat('p.',num2str(p),'n',num2str(n),'.txt');
        J=ones(n);
        DNNproblem.C=-J;
        DNNproblem.A=importdata(dataname)+eye(n);
        DNNproblem.b=1;
        
        
        
        for ll=1:2
            if ll==1
                key=-1;
                %test for DD no crossover 2020.11.1
                %key=2;
                %params.crossover = 0;%0->off
                %
                vec44=load(strcat('DD_',num2str(n),'.mat'));
                vec=[sparse(vec44.vec)];
                clear vec44
            else
                key=2;
                params.crossover = 0;%0->off
                %params.BarConvTol=10^-3;%barrier accuracy
                vec55=load(strcat('SDbaseopt_',num2str(n),'.mat'));
                vec=[sparse(vec55.vec)];
                clear vec55
            end
            
            
            %% model module
            tic;
            model.obj =sym2vecdoubledense(DNNproblem.C,n);
            sizevec=size(vec,2);
            A=-transpose(vec);
            Aeq=transpose(sym2vecdouble(DNNproblem.A,n));
            model.A = [A; Aeq];
            model.rhs = [zeros(sizevec,1); transpose(DNNproblem.b)];
            model.sense = [repmat('<', size(A,1), 1); repmat('=', size(Aeq,1), 1)];
            model.lb=zeros(nsym,1);
            model.ub=inf(nsym,1);
            params.Method=key;
            params.outputflag = 0;
            formulationtime=toc;
            %%
            
            time=[];
            for kk=1:l
                datetime
                if ll==1
                    strcat('counting_p.',num2str(p),'n',num2str(n),'_DD_',num2str(kk),'/3')
                else
                    strcat('counting_p.',num2str(p),'n',num2str(n),'_opt_',num2str(kk),'/3')
                end
                
                if kk==1
                    result=DNNcuttinglowsymdouble(model,params,n,cuttime);
                    countsize=size(result.fl,2);
                    time(kk,:)=result.cputime;
                else
                    result=DNNcuttinglowsymdoublecount(model,params,n,countsize);
                    time(kk,:)=result.cputime;
                end
            end
            
            result.fl=-result.fl;
            result.cputime=[];
            result.cputime=mean(time);
            result.totaltime=result.cputime(end);
            result.formulationtime=formulationtime;
            
            if key==0
                method='pSimplex';
            elseif key==1
                method='dSimplex';
            elseif key==2
                method='Barrier';
            else
                method='Default';
            end
            
            if ll==1
                name=strcat('Paper_result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_DD_',method,'_20.10.17.mat');
                %name=strcat('Paper_result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_DD_barrier_nocrossover',method,'_20.11.1.mat');
            else 
                name=strcat('Paper_result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_opt_',method,'_20.10.17.mat');
            end
            save(name,'result');
        end
    end
end
