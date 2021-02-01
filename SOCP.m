function [x, fval, exitflag, runtime]=SOCP(n,model,params)
params.qcpdual=1;
result = gurobi(model,params);
runtime=result.runtime;
if strcmp(result.status, 'OPTIMAL')
    exitflag = 1;
elseif strcmp(result.status, 'ITERATION_LIMIT')
    exitflag = 0;
elseif strcmp(result.status, 'INF_OR_UNBD')
    params.dualreductions = 0;
    result = gurobi(model, params);
    if strcmp(result.status, 'INFEASIBLE')
        exitflag = -2;
    elseif strcmp(result.status, 'UNBOUNDED')
        exitflag = -3;
    else
        exitflag = nan;
    end
elseif strcmp(result.status, 'INFEASIBLE')
    exitflag = -2;
elseif strcmp(result.status, 'UNBOUNDED')
    exitflag = -3;
else
    exitflag = nan;
end
if isfield(result, 'x')
    x = result.x;
else
    x = nan(n,1);
end


if isfield(result, 'objval')
    fval = result.objval;
else
    fval = nan;
end

