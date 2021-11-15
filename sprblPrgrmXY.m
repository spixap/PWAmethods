%%%%%% Seperable programming approximation of function f(x,y)=xy %%%%%%%%%%
%%
clearvars; close all;
% Set I of discretization points
par.I = 21;

par.x_min = 0.2;
par.x_max = 1;
x = linspace(par.x_min,par.x_max,par.I); 

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
% x_var   = optimvar('x_var','LowerBound',par.x_min,'UpperBound',par.x_max);
% u1      = optimvar('u1','LowerBound',min(fun),'UpperBound',max(fun));

%% -------------------\\ Optimization Constraints \\------------------------

% u1
varNames = {'u_1_x_var','u_1_h','u_1_alpha','u_1'};

u1_alphaCnstr = optimconstr(par.I);

u1_struct = funSeperablePWA(par,varNames);

u1_hSOS1a       = u1_struct.Constraints.hSOS1a;
u1_hSOS1b       = u1_struct.Constraints.hSOS1b;
u1_hSOS1c       = u1_struct.Constraints.hSOS1c;
u1_alphaCnstr(:)= u1_struct.Constraints.alphaCnstr;
u1_sumAlpha     = u1_struct.Constraints.sumAlpha;
u1_xValueEst    = u1_struct.Constraints.xValueEst;
u1_funValue     = u1_struct.Constraints.funValue;

prob.Constraints.u1_hSOS1a     = u1_hSOS1a;
prob.Constraints.u1_hSOS1b     = u1_hSOS1b;
prob.Constraints.u1_hSOS1c     = u1_hSOS1c;
prob.Constraints.u1_alphaCnstr = u1_alphaCnstr;
prob.Constraints.u1_sumAlpha   = u1_sumAlpha;
prob.Constraints.u1_xValueEst  = u1_xValueEst;
prob.Constraints.u1_funValue   = u1_funValue;

u1 = prob.Variables.u_1;
x_var = prob.Variables.u_1_x_var;

% Additional Constraint (just for demonstration): y >= x
linearityCnstr = u1 >= slope*x_var;
prob.Constraints.linearityCnstr = linearityCnstr;
%% -------------------\\ Optimization Objective \\--------------------------
prob.Objective = u1;
%% --------------------\\ Optimization Solution \\-------------------------
options = optimoptions('intlinprog');
[sol,f_sol] = solve(prob,'Options',options);
%-----------------------\\ Optimal Solution Plot\\-------------------------
p_fun   = plot(x,fun,'k','LineWidth',1.5,'DisplayName','f(x)');xlabel('x');ylabel('f(x)');grid on;hold on;
s_fun   = scatter(x,fun,'bs','filled','DisplayName','Data Points');
s_opt   = scatter(sol.u_1_x_var,f_sol,'ro','filled','DisplayName','Optimal Point');
p_cnstr = plot(x,slope*x,'g','LineWidth',2,'DisplayName','y=x');legend;

legend([p_fun,s_fun,s_opt,p_cnstr],{'$f(x)$','$f(x_i)$','$f(x^*)$',['$f(x) \ge',num2str(slope),'x$']},'FontSize',12,...
    'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeast');
        
f_x = sol.u_1_x_var^2;