function [obj,solvertime,info,runhist]=sdptsolver(n,m,DNNproblem)
nsym=n*(n-1)*0.5;
C{1}=[DNNproblem.C sparse(n,nsym);sparse(nsym,n) sparse(nsym,nsym)];
for i=1:m
At{1,i}=[DNNproblem.A(i).A sparse(n,nsym);sparse(nsym,n) sparse(nsym,nsym)];
end
count=1;
for i=1:n
    for j=i:n
        if i~=j
            At{1,m+count}=sparse(n+nsym,n+nsym);
            At{1,m+count}(i,j)=1;
            At{1,m+count}(n+count,n+count)=-1;
            count=count+1;
        end
    end
end
options.printlevel = 0;
b = [transpose(DNNproblem.b);sparse(count-1,1)];
   blk{1,1} = 's'; blk{1,2} = [n,ones(1,nsym)]; 
   tic;
   [obj1,X,~,~,info,runhist] = sqlp(blk,At,C,b,options);
   solvertime=toc;
   obj=-transpose(obj1);

