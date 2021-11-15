%%%%%%%%%%%%%%%%% PWA approximation of function f(x) %%%%%%%%%%%%%%%%%%%%%%
%%
clearvars; close all;
% Set I of discretization points
I = 21;
% Set of n coordinates on X axis: 1,...,n (x1=0, xn=6)
n = I;

x_min = 0.2;
x_max = 1;
x = linspace(x_min,x_max,I); 

% -------------------\\ INPUT: Function y = f(x) \\------------------------
% fun = 208.45*x.^2-422.84.*x+433.82;
% slope = 287;

% fun = 1./x;
% slope = 4;

fun = x.^2;
slope = 0.5;

%% --------------------\\ Optimization Problem \\--------------------------
prob = optimproblem('ObjectiveSense','minimize');
% -------------------\\ Optimization Variables \\--------------------------
x_var   = optimvar('x_var','LowerBound',x_min,'UpperBound',x_max);

h_i     = optimvar('h',n+1,'Type','integer','LowerBound',0,'UpperBound',1);
alpha_i = optimvar('alpha',n,'LowerBound',0,'UpperBound',1);

f_a = optimvar('f_a','LowerBound',0,'UpperBound',1000);

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
prob.Objective = f_a;
% -------------------\\ Optimization Constraints \\------------------------
alphaCnstr = optimconstr(n);
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
prob.Constraints.xValueEst = x_var == x * alpha_i;


% f_a value estimation
prob.Constraints.funValue = f_a ==  fun * alpha_i;

% Additional Constraint (just for demonstration): y >= x
linearityCnstr = f_a >= slope*x_var;
prob.Constraints.linearityCnstr = linearityCnstr;
%% --------------------\\ Optimization Solution \\-------------------------
options = optimoptions('intlinprog');
[sol,f_sol] = solve(prob,'Options',options);
%-----------------------\\ Optimal Solution Plot\\-------------------------
p_fun   = plot(x,fun,'k','LineWidth',1.5,'DisplayName','f(x)');xlabel('x');ylabel('f(x)');grid on;hold on;
s_fun   = scatter(x,fun,'bs','filled','DisplayName','Data Points');
s_opt   = scatter(sol.x_var,f_sol,'ro','filled','DisplayName','Optimal Point');
p_cnstr = plot(x,slope*x,'g','LineWidth',2,'DisplayName','y=x');legend;

legend([p_fun,s_fun,s_opt,p_cnstr],{'$f(x)$','$f(x_i)$','$f(x^*)$',['$f(x) \ge',num2str(slope),'x$']},'FontSize',12,...
    'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeast');
        
f_x = sol.x_var^2;