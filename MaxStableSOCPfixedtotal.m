clear
clc
ne=[150;200;250;300];
pe=[3;8];
delta=10^-6;
cuttime=600;
l=3;
for i=1:4
    for j=1:2
        n=ne(i);
        nsym=0.5*n*(n+1);
        p=pe(j);
        dataname=strcat('p.',num2str(p),'n',num2str(n),'.txt');
        J=ones(n);
        DNNproblem.C=-J;
        DNNproblem.A=importdata(dataname)+eye(n);
        DNNproblem.b=1;
        C=sym2vecdoubledense(DNNproblem.C,n);
        A=transpose(sym2vecdouble(DNNproblem.A,n));
        b=transpose(DNNproblem.b);
        m=1;
        
        percent=2;
        
        
        tic;
        prob=mosekDNNSOCPformulation(n,m,C,A,b);
        formulationtime=toc;
        for ll=1:2
            if ll==1
                time=[];
                for kk=1:l
                    datetime
                    strcat('counting_p.',num2str(p),'n',num2str(n),'_SOCP_',num2str(kk),'/3')
                    
                    if kk==1
                        result=mosekQCPpercent(prob,n,cuttime,percent);
                        countsize=size(result.fl,2);
                        time(kk,:)=result.cputime;
                    else
                        result=mosekQCPpercentcount(prob,n,countsize,percent);
                        time(kk,:)=result.cputime;
                    end
                    
                end
            elseif ll==2
                time=[];
                for kk=1:l
                    datetime
                    strcat('counting_p.',num2str(p),'n',num2str(n),'_SOCPCUT_',num2str(kk),'/3')
                    
                    if kk==1
                        result=mosekQCP_SOCPcutpercent(prob,n,m,cuttime,percent);
                        countsize=size(result.fl,2);
                        time(kk,:)=result.cputime;
                    else
                        result=mosekQCP_SOCPcutpercentcount(prob,n,m,countsize,percent);
                        time(kk,:)=result.cputime;
                    end
                    
                end
            end
            
            result.formulationtime=formulationtime;
            result.fl=-result.fl;
            result.cputime=[];
            result.cputime=mean(time);
            result.totaltime=result.cputime(end);
            
            if ll==1
                name=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SOCPmosek_10.15.mat')
            elseif ll==2
                name=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SOCPmosek_SOCPcut_10.15.mat')
            end
            save(name,'result');
            
        end
    end
    
end

