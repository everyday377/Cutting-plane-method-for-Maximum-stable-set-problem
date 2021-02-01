function prob=mosekDNNSDPformulation(n,m,DNNproblem)%A=[vecA1^T;vecA2^T;...]
           [r, res] = mosekopt('symbcon');
            
            
            prob.bardim = [n];
            
            [prob.barc.subk,prob.barc.subl,prob.barc.val] = find(tril(DNNproblem.C));
            prob.barc.subj=ones(size(prob.barc.subk,1),1);
            
            prob.blc = transpose(DNNproblem.b);
            prob.buc = transpose(DNNproblem.b);
            
            [prob.bara.subk,prob.bara.subl,prob.bara.val]=find(tril(DNNproblem.A(1).A));
            prob.bara.subi=ones(size(prob.bara.subk,1),1);%constraint indices
            for p=2:m
                [asubk,asubl,aval]=find(tril(DNNproblem.A(p).A));
                prob.bara.subk=[prob.bara.subk;asubk];
                prob.bara.subl=[prob.bara.subl;asubl];
                prob.bara.val=[prob.bara.val;aval];
                prob.bara.subi=[prob.bara.subi; p*ones(size(asubk,1),1)];           
            end
            
             count=1;
             for i=2:n
                 for j=1:i-1
                     prob.bara.subi=[prob.bara.subi;m+count];
                     prob.bara.subk=[prob.bara.subk;i];
                     prob.bara.subl=[prob.bara.subl;j];
                     prob.bara.val=[prob.bara.val;1];
                     prob.blc=[prob.blc;0];
                     prob.buc=[prob.buc;inf];
                     count=count+1;
                 end
             end
            
            prob.bara.subj=ones(size(prob.bara.subi,1),1);%variable indices
            prob.a=sparse(size(prob.blc,1),0);
            
            
            
            
            








