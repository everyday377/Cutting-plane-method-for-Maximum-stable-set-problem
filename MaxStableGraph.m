clear
clc
ne=[150;200;250;300];
pe=[3;8];
ii=4;
cc=1;
no=1;
for i=ii:ii
    for j=cc:cc
            n=ne(i);
            p=pe(j);
            name1=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_DD_Default_10.15.mat');
            result1=importdata(name1);
            name2=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_opt_Barrier_10.15.mat');%_half2
            result2=importdata(name2);
            name3=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SDB_Partial_Per_0.3_No._',num2str(no),'_20.10.13.mat');
            result3=importdata(name3);
            name4=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SDB_Partial_Per_0.5_No._',num2str(no),'_20.10.13.mat');
            result4=importdata(name4);
            name5=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SDB_Partial_Per_0.8_No._',num2str(no),'_20.10.13.mat');
            result5=importdata(name5);
           
            
            
            ite1=size(result1.fl,2);
            ite2=size(result2.fl,2);
            ite3=size(result3.fl,2);
            ite4=size(result4.fl,2);
            ite5=size(result5.fl,2);
            
            if i==4
                if j==1
                    resultMosek.obj=29.13;
                    resultMosek.solvertime=32300.6;
                elseif j==2
                    resultMosek.obj=7.65;
                    resultMosek.solvertime=20586.02;
                end
            else
                nameMosek=strcat('result_p.',num2str(p),'n',num2str(n),'_MaxStableSet_SDPmosek_10.4.mat');
                resultMosek=importdata(nameMosek);
            end
            
             fMosek1=ones(1,ite1)*resultMosek.obj;
             fMosek2=ones(1,ite2)*resultMosek.obj;
             fMosek3=ones(1,ite3)*resultMosek.obj;
             fMosek4=ones(1,ite4)*resultMosek.obj;
             fMosek5=ones(1,ite5)*resultMosek.obj;
             
            opt=resultMosek.obj;

             interval1=-(fMosek1-result1.fl)/abs(opt);
             interval2=-(fMosek2-result2.fl)/abs(opt);
             interval3=-(fMosek3-result3.fl)/abs(opt);
             interval4=-(fMosek4-result4.fl)/abs(opt);
             interval5=-(fMosek5-result5.fl)/abs(opt);
     
            solvertime(1)=resultMosek.solvertime;
          
            cputime1=result1.cputime;
            cputime2=result2.cputime;
            cputime3=result3.cputime;
            cputime4=result4.cputime;
            cputime5=result5.cputime;

            plot(cputime1,interval1,'k','LineWidth',1.5)
            hold on
            plot(cputime2,interval2,'r','LineWidth',1.5)
            
            plot(cputime3,interval3,'b','LineWidth',1.5)
            
            plot(cputime4,interval4,'g','LineWidth',1.5)
            plot(cputime5,interval5,'m','LineWidth',1.5)
            
%             plot(1:ite1,interval1,'k','LineWidth',1.5)
%             hold on
%             plot(1:ite2,interval2,'r','LineWidth',1.5)
% 
%             plot(1:ite3,interval3,'b','LineWidth',1.5)
%             
%             plot(1:ite4,interval4,'g','LineWidth',1.5)
%             plot(1:ite5,interval5,'m','LineWidth',1.5)
            
            legend('CPDD','CPESDB','CPSDB0.3','CPSDB0.5','CPSDB0.8')
            legend({},'FontSize',13)
            title(strcat('Max Stable set problem  (n=',num2str(n),',p=0.',num2str(p),')'))
            xlabel('Time (s)')
            %xlabel('Iterations')
            ylabel('Gap')
            %dim = [.68 .38 .3 .3];
            %str={'Solver time:',strcat('Mosek= ',num2str(round(solvertime(1),1)),'s')};
            %annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
                 ylim([0 7])
                 %xlim([0 700])
                 xlim([0 600])



    end
end