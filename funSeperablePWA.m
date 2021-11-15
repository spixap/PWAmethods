function [tempProb] = funSeperablePWA(par,varNames)
%funSeperablePWA Summary of this function goes here
%   Detailed explanation goes here

% Set I of discretization points
I = par.I;
% Set of n coordinates on X axis: 1,...,n (x1=0, xn=6)
n = I;
% -------------------\\ INPUT: Function y = f(x) \\------------------------
x_min = par.x_min;
x_max = par.x_max;
x = linspace(x_min,x_max,I);

% Function to approximate:
%     fun = 1./x;
fun = x.^2;
%% --------------------\\ Optimization Problem \\--------------------------
tempProb = optimproblem('ObjectiveSense','minimize');
% -------------------\\ Optimization Variables \\-------------------------
x_var   = optimvar(varNames{1},'LowerBound',x_min,'UpperBound',x_max);
h_i     = optimvar(varNames{2},n+1,'Type','integer','LowerBound',0,'UpperBound',1);
alpha_i = optimvar(varNames{3},n,'LowerBound',0,'UpperBound',1);
f_a     = optimvar(varNames{4},'LowerBound',min(fun),'UpperBound',max(fun));

% Naming variables indexes
indexNames_i = cell(n,1);
indexNames_h = cell(n+1,1);

for i = 1 : n
    indexNames_i{i,1} = append('i_',int2str(i));
end
for i = 1 : n+1
    indexNames_h{i,1} = append('i_',int2str(i-1));
end

h_i.IndexNames{1} = indexNames_h;
alpha_i.IndexNames{1} = indexNames_i;
% -------------------\\ Optimization Objective \\--------------------------
tempProb.Objective = f_a;
% -------------------\\ Optimization Constraints \\------------------------
alphaCnstr = optimconstr(n);
% SOS1 on binaries h
tempProb.Constraints.hSOS1a = h_i(1) == 0;
tempProb.Constraints.hSOS1b = h_i(end) == 0;
tempProb.Constraints.hSOS1c = sum(h_i(2:end-1)) == 1;

% Linear weights constraints
for i = 1 : n
    index_i = append('i_',int2str(i));
    index_i_prev = append('i_',int2str(i-1));
    alphaCnstr(i) = alpha_i(index_i) <= h_i(index_i_prev) + h_i(index_i) ;
end
tempProb.Constraints.alphaCnstr = alphaCnstr;

% Sum of alphas is 1 (convexity)
tempProb.Constraints.sumAlpha = sum(alpha_i) == 1;

% x value estimation
tempProb.Constraints.xValueEst = x_var == x * alpha_i;

% f_a value estimation
tempProb.Constraints.funValue = f_a ==  fun * alpha_i;

end