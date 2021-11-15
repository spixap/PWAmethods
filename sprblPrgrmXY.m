%%%%%% Seperable programming approximation of function f(x,y)=xy %%%%%%%%%%
%%
clearvars; close all;
% Set I of discretization points
par.I = 21;

% Set of n coordinates on X axis: 1,...,n (x1=0, xn=6)
n = par.I;
% Set of m coordinates on Y axis: 1,...,m (y1=0, ym=6)
m = par.I;

% Test Function Selection (1-6):
funSlct = 1;
varRanges = 'paper'; % {'physical','paper'}
activeCstrX = 1;
activeCstrY = 0;


if funSlct == 1
    if strcmp(varRanges,'physical') == 1
        par.x_min = 45;
        par.x_max = 50;
        par.y_min = 0;
        par.y_max = 6;
        minFunVal   = 0;
        maxValFun   = 300;
%         csntrFunVal = 200;
%         csntrXval = 47;
        x = linspace(x_min,x_max,n);
        y = linspace(y_min,y_max,m);
        [X,Y] = meshgrid(x,y);
    elseif strcmp(varRanges,'paper') == 1
        par.x_min = 0;
        par.x_max = 6;
        par.y_min = 0;
        par.y_max = 6;
        minFunVal   = 0;
        maxValFun   = 40;
%         csntrFunVal = 10;
%         csntrXval = par.x_min;
        x = linspace(par.x_min,par.x_max,n);
        y = linspace(par.y_min,par.y_max,m);
        [X,Y] = meshgrid(x,y);
    end
    
    z = linspace(minFunVal,maxValFun,m);
    [Z,~] = meshgrid(z,y);                  % level x = C
else
    x_min = 0;
    x_max = 6;
    y_min = 0;
    y_max = 6;
    x = linspace(par.x_min,par.x_max,n);
    y = linspace(par.y_min,par.y_max,m);
    [X,Y] = meshgrid(x,y);
end

fun = Y.*X;
minFunVal   = 0;
maxValFun   = 40;
csntrFunVal = 10;

if (activeCstrX == 1) && (activeCstrY == 0)
    csntrXval = 5;
    z = linspace(minFunVal,maxValFun,m);
    [Z,~] = meshgrid(z,y);                  % level x = C
elseif (activeCstrY == 1) && (activeCstrX == 0)
    csntrYval = 3;
    z = linspace(minFunVal,maxValFun,m);
    [~,Z] = meshgrid(x,z);                  % level y = C
elseif (activeCstrX == 1) && (activeCstrY == 1)
    csntrXval = 2;
    csntrYval = 2;
    z = linspace(minFunVal,maxValFun,m);
    [Zx,~] = meshgrid(z,y);
    [~,Zy] = meshgrid(x,z);
end
    
% csntrXval = 3;
% csntrYval = 5;


% -------------------\\ INPUT: Function y = f(x) \\------------------------
% fun = 208.45*x.^2-422.84.*x+433.82;
% slope = 287;

% fun = 1./x;
% slope = 4;

% fun = x.^2;
% slope = 0.5;

%% --------------------\\ Optimization Problem \\--------------------------
prob = optimproblem('ObjectiveSense','minimize');
% -------------------\\ Optimization Variables \\--------------------------
x_var   = optimvar('x_var','LowerBound',par.x_min,'UpperBound',par.x_max);
y_var   = optimvar('y_var','LowerBound',par.y_min,'UpperBound',par.y_max);
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

% u2
par.x_min = par.y_min;
par.x_max = par.y_max;

varNames = {'u_2_x_var','u_2_h','u_2_alpha','u_2'};

u2_alphaCnstr = optimconstr(par.I);

u2_struct = funSeperablePWA(par,varNames);

u2_hSOS1a       = u2_struct.Constraints.hSOS1a;
u2_hSOS1b       = u2_struct.Constraints.hSOS1b;
u2_hSOS1c       = u2_struct.Constraints.hSOS1c;
u2_alphaCnstr(:)= u2_struct.Constraints.alphaCnstr;
u2_sumAlpha     = u2_struct.Constraints.sumAlpha;
u2_xValueEst    = u2_struct.Constraints.xValueEst;
u2_funValue     = u2_struct.Constraints.funValue;

prob.Constraints.u2_hSOS1a     = u2_hSOS1a;
prob.Constraints.u2_hSOS1b     = u2_hSOS1b;
prob.Constraints.u2_hSOS1c     = u2_hSOS1c;
prob.Constraints.u2_alphaCnstr = u2_alphaCnstr;
prob.Constraints.u2_sumAlpha   = u2_sumAlpha;
prob.Constraints.u2_xValueEst  = u2_xValueEst;
prob.Constraints.u2_funValue   = u2_funValue;

u2 = prob.Variables.u_2;

prob.Constraints.u1_x_y = prob.Variables.u_1_x_var == 0.5*(x_var + y_var);
prob.Constraints.u2_x_y = prob.Variables.u_2_x_var == 0.5*(x_var - y_var);


% Additional Constraint: fun == c (set level)
prob.Constraints.linearityCnstr = u1 - u2 >= csntrFunVal;

% prob.Constraints.linearityCnstr2 = x_var == csntrXval;

if (activeCstrX == 1) && (activeCstrY == 0)
    prob.Constraints.linearityCnstr2 = x_var == csntrXval;
elseif (activeCstrY == 1) && (activeCstrX == 0)
    prob.Constraints.linearityCnstr2 = y_var == csntrYval;
elseif (activeCstrX == 1) && (activeCstrY == 1)
    prob.Constraints.linearityCnstr2 = x_var == csntrXval;
    prob.Constraints.linearityCnstr3 = y_var == csntrYval;
end


%% -------------------\\ Optimization Objective \\--------------------------
prob.Objective = u1 - u2;
%% --------------------\\ Optimization Solution \\-------------------------
options = optimoptions('intlinprog');
[sol,f_sol] = solve(prob,'Options',options);
%-----------------------\\ Optimal Solution Plot\\-------------------------
% p_fun   = plot(x,fun,'k','LineWidth',1.5,'DisplayName','f(x)');xlabel('x');ylabel('f(x)');grid on;hold on;
% s_fun   = scatter(x,fun,'bs','filled','DisplayName','Data Points');
% s_opt   = scatter(sol.u_1_x_var,f_sol,'ro','filled','DisplayName','Optimal Point');
% p_cnstr = plot(x,slope*x,'g','LineWidth',2,'DisplayName','y=x');legend;
% 
% legend([p_fun,s_fun,s_opt,p_cnstr],{'$f(x)$','$f(x_i)$','$f(x^*)$',['$f(x) \ge',num2str(slope),'x$']},'FontSize',12,...
%     'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeast');
%         
f_xy = sol.x_var * sol.y_var;
%% -----------------------\\ Optimal Solution Plot\\-------------------------
p = surf(X,Y,fun,'FaceAlpha',0.8,'DisplayName','function');xlabel('x');ylabel('y');zlabel('f(x,y)');grid on;hold on;
s = scatter3(sol.x_var,sol.y_var,f_sol,'ro','filled','DisplayName','f_{xy}^*');

s.SizeData = 40;
c1 = mesh(X,Y,csntrFunVal*ones(n,m),'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_1');

% if funSlct == 1
%     c2 = mesh(csntrXval*ones(n,m),Y,Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
% end

if (activeCstrX == 1) && (activeCstrY == 0)
    c2 = mesh(csntrXval*ones(n,m),Y,Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
elseif (activeCstrY == 1) && (activeCstrX == 0)
    c2 = mesh(X,csntrYval*ones(n,m),Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
elseif (activeCstrX == 1) && (activeCstrY == 1)
    c2 = mesh(csntrXval*ones(n,m),Y,Zx,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
    c3 = mesh(X,csntrYval*ones(n,m),Zy,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_3');
end

%% -----------------------\\Validation of solution\\-------------------------
f = scatter3(sol.x_var,sol.y_var,f_xy,20,'b*','DisplayName','f(x^*,y^*)');

if (activeCstrX == 1) && (activeCstrY == 0)
    legend([p,s,c1,c2,f],{'$f(x,y)$','$\hat{f}_{xy}^*$',['$f \ge',num2str(csntrFunVal),'$'],['$x =',num2str(csntrXval),'$'],'$f(x^*,y^*)$'},'FontSize',12,...
        'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeastoutside');
elseif (activeCstrY == 1) && (activeCstrX == 0)
    legend([p,s,c1,c2,f],{'$f(x,y)$','$\hat{f}_{xy}^*$',['$f \ge',num2str(csntrFunVal),'$'],['$y =',num2str(csntrYval),'$'],'$f(x^*,y^*)$'},'FontSize',12,...
        'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeastoutside');
elseif (activeCstrX == 1) && (activeCstrY == 1)
    legend([p,s,c1,c2,c3,f],{'$f(x,y)$','$\hat{f}_{xy}^*$',['$f \ge',num2str(csntrFunVal),'$'],['$x =',num2str(csntrXval),'$'],...
        ['$y =',num2str(csntrYval),'$'],'$f(x^*,y^*)$'},'FontSize',12,...
        'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeastoutside');
else
    legend([p,s,c1,f],{'$f(x,y)$','$\hat{f}_{xy}^*$',['$f \ge',num2str(csntrFunVal),'$'],'$f(x^*,y^*)$'},'FontSize',12,...
        'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeastoutside');
end