%%%%%%%%%% PWA approximation of function of 2 variables f(x,y) %%%%%%%%%%%%
clearvars -except spi_temp ;
close all;

I = 201;
% Set of n coordinates on X axis: 1,...,n (x1=0, xn=6)
n = I;

% Set of m coordinates on Y axis: 1,...,m (y1=0, ym=6)
m = I;

bigM = 100000;

% bigM = 1000000;

% bigM = 1000;


% minFunVal   = -6;
% maxValFun   = 8;

% minFunVal   = 0;
% maxValFun   = 300;

minFunVal   = 0;
maxValFun   = 300;

csntrFunVal = 217;

% -------------------\\ INPUT: Function fun = f(x,y) \\------------------------
% x_min = 0;
% x_max = 6;
% y_min = 0;
% y_max = 6;

x_min = 0;
x_max = 6;

y_min = 45;
y_max = 50;


% x_min = 0;
% x_max = 1;
% 
% y_min = 0;
% y_max = 1;

x = linspace(x_min,x_max,n); 
y = linspace(y_min,y_max,m); 
[X,Y] = meshgrid(x,y);

z = linspace(minFunVal,maxValFun,m);
[~,Z] = meshgrid(x,z);

% Functions to approximate:
fun = Y.*X;
% fun = Y.*sin((X-3)*pi/4);
% fun = ((10-Y).^3).*sin((X-1)*pi/4);
% fun = Y + sin((X-3)*pi/4);
% fun = Y.*sin((X-1)*pi/4);
% fun = Y.*cos((X-1)*pi/4);

%% --------------------\\ Optimization Problem \\--------------------------
prob = optimproblem('ObjectiveSense','minimize');
% -------------------\\ Optimization Variables \\--------------------------
% y_var   = optimvar('y_var','LowerBound',y_min,'UpperBound',y_max);
% x_var   = optimvar('x_var','LowerBound',x_min,'UpperBound',x_max);

y_var   = optimvar('y_var','LowerBound',y_min,'UpperBound',y_max);
x_var   = optimvar('x_var','LowerBound',x_min,'UpperBound',x_max);

beta_j  = optimvar('beta',m,'Type','integer','LowerBound',0,'UpperBound',1);
h_i     = optimvar('h',n+1,'Type','integer','LowerBound',0,'UpperBound',1);
alpha_i = optimvar('alpha',n,'LowerBound',0,'UpperBound',1);
f_a     = optimvar('f_a','LowerBound',minFunVal,'UpperBound',maxValFun);


% Naming variables indexes
indexNames_i = cell(n,1);
indexNames_j = cell(m,1);
indexNames_h = cell(n+1,1);

for i = 1 : n
    indexNames_i{i,1} = append('i_',int2str(i));
end
for j = 1 : m
    indexNames_j{j,1} = append('j_',int2str(j));
end
for i = 1 : n+1
    indexNames_h{i,1} = append('i_',int2str(i-1));
end

beta_j.IndexNames{1} = indexNames_j;
h_i.IndexNames{1} = indexNames_h;
alpha_i.IndexNames{1} = indexNames_i;

% -------------------\\ Optimization Objective \\--------------------------
prob.Objective = f_a;
% -------------------\\ Optimization Constraints \\------------------------

% -----------VARIABLE X
alphaCnstr = optimconstr(n);
functionValueCnstrA = optimconstr(m-1);
functionValueCnstrB = optimconstr(m-1);

% SOS1 on binaries h
prob.Constraints.hSOS1a = h_i(1) == 0;
prob.Constraints.hSOS1b = h_i(end) == 0;
prob.Constraints.hSOS1c = sum(h_i(2:end-1)) == 1;

% Linear weights constraints
for i = 1 : n
    index_i = append('i_',int2str(i));
    index_i_prev = append('i_',int2str(i-1));
    alphaCnstr(i) = alpha_i(index_i) <= h_i(index_i_prev) + h_i(index_i) ;
end
prob.Constraints.alphaCnstr = alphaCnstr;

% Sum of alphas is 1 (convexity)
prob.Constraints.sumAlpha = sum(alpha_i) == 1;

% x value estimation
temp0 = 0;
for i = 1 : n
    index_i = append('i_',int2str(i));
    temp0 = temp0 + alpha_i(index_i) * y(i);
end
prob.Constraints.xValueEst = y_var == temp0;


% ---------VARIABLE Y

% Upper Limit of y value for j interval
temp1 = 0;
for j = 1 : m-1
    index_j = append('j_',int2str(j));
    temp1 = temp1 + beta_j(index_j) * x(j+1);
end
prob.Constraints.slctUpperYlim = x_var <= temp1 - 2*10^(-4) ;

% Lower Limit of y value for j interval
temp2 = 0;
for j = 1 : m-1
    index_j = append('j_',int2str(j));
    temp2 = temp2 + beta_j(index_j) * x(j);
end
prob.Constraints.slctLowerYlim = x_var >= temp2;

% SOS1 on binaries beta
prob.Constraints.sumBeta = sum(beta_j(1:end-1)) == 1;

% ---------VALUE FUNCTION
% Lower Limit of function approximation f_a for j interval

for j = 1 : m-1
    temp3 = 0;
    for i = 1 : n
        index_i = append('i_',int2str(i));
        temp3 = temp3 + alpha_i(index_i) * fun(i,j);
    end    
    index_j = append('j_',int2str(j));
    functionValueCnstrA(j) = f_a <= temp3 + bigM * (1-beta_j(index_j));
end
prob.Constraints.functionValueCnstrA = functionValueCnstrA;

for j = 1 : m-1
    temp4 = 0;
    for i = 1 : n
        index_i = append('i_',int2str(i));
        temp4 = temp4 + alpha_i(index_i) * fun(i,j);
    end
    index_j = append('j_',int2str(j));
    functionValueCnstrB(j) = f_a >= temp4 - bigM * (1-beta_j(index_j));
end
prob.Constraints.functionValueCnstrB = functionValueCnstrB;

% Additional Constraint: fun == c (set level)
prob.Constraints.linearityCnstr = f_a >= csntrFunVal;
prob.Constraints.linearityCnstr2 = y_var == 47;

%% --------------------\\ Optimization Solution \\-------------------------
options = optimoptions('intlinprog');
[sol,f_sol] = solve(prob,'Options',options);
%% -----------------------\\ Optimal Solution Plot\\-------------------------
mesh(X,Y,fun,'DisplayName','function');xlabel('x');ylabel('y');zlabel('f(x,y)');grid on;hold on;
% scatter3(sol.y_var,sol.x_var,f_sol,'ro','filled','DisplayName','Optimal Point');
scatter3(sol.x_var,sol.y_var,f_sol,'ro','filled','DisplayName','Optimal Point');
surf(X,Y,csntrFunVal*ones(n,m),'DisplayName','constraint_1');
surf(X,47*ones(n,m),Z,'DisplayName','constraint_2');
legend;