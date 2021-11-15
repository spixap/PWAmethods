%%%%%%%%%%%%%%%%%%%% PWA of f(x,y) triangles method %%%%%%%%%%%%%%%%%%%
%%
clearvars -except spi_temp;
close all;

I = 21; % 200
% Set of n coordinates on X axis: 1,...,n (x1=0, xn=6)
n = I;
% Set of m coordinates on Y axis: 1,...,m (y1=0, ym=6)
m = I;

bigM = 100000;

% -------------------\\ INPUT: Function fun = f(x,y) \\------------------------
 
% % ------x: voltage and y: current

% Test Function Selection (1-6):
funSlct = 1;
varRanges = 'paper'; % {'physical','paper'}
activeCstrX = 1;
activeCstrY = 1;


if funSlct == 1
    if strcmp(varRanges,'physical') == 1
        x_min = 45;
        x_max = 50;
        y_min = 0;
        y_max = 6;
        minFunVal   = 0;
        maxValFun   = 300;
        csntrFunVal = 200;
        csntrXval = 47;
        x = linspace(x_min,x_max,n);
        y = linspace(y_min,y_max,m);
        [X,Y] = meshgrid(x,y);
    elseif strcmp(varRanges,'paper') == 1
        x_min = 0;
        x_max = 6;
        y_min = 0;
        y_max = 6;
        minFunVal   = 0;
        maxValFun   = 40;
        csntrFunVal = 10;
        csntrXval = 5;
        x = linspace(x_min,x_max,n);
        y = linspace(y_min,y_max,m);
        [X,Y] = meshgrid(x,y);
    end
    
    z = linspace(minFunVal,maxValFun,m);
    [Z,~] = meshgrid(z,y);                  % level x = C
else
    x_min = 0;
    x_max = 6;
    y_min = 0;
    y_max = 6;
    x = linspace(x_min,x_max,n);
    y = linspace(y_min,y_max,m);
    [X,Y] = meshgrid(x,y);
end
        
% Functions to approximate:
if funSlct == 1
    fun = Y.*X;
    minFunVal   = 0;
    maxValFun   = 40;
    csntrFunVal = 15;
elseif funSlct == 2
    fun = Y.*sin((X-3)*pi/4);
    minFunVal   = -6;
    maxValFun   = 6;
    csntrFunVal = 3;
    
    if (activeCstrX == 1) && (activeCstrY == 0)
       csntrXval = 2;
       z = linspace(minFunVal,maxValFun,m);
       [Z,~] = meshgrid(z,y);                  % level x = C
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m); 
        [~,Z] = meshgrid(x,z);                  % level y = C
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        csntrXval = 2;
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m);
        [Zx,~] = meshgrid(z,y); 
        [~,Zy] = meshgrid(x,z); 
    else
        csntrYval   = 3.1;
        z = linspace(minFunVal,maxValFun,m); 
        [~,Z] = meshgrid(z,y);                  % level y = C        
    end

elseif funSlct == 3
    fun = ((10-Y).^3).*sin((X-1)*pi/4);
    minFunVal   = -800;
    maxValFun   = 1000;
    csntrFunVal = -800;
    if (activeCstrX == 1) && (activeCstrY == 0)
       csntrXval = 2;
       z = linspace(minFunVal,maxValFun,m);
       [Z,~] = meshgrid(z,y);                  % level x = C
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m); 
        [~,Z] = meshgrid(x,z);                  % level y = C
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        csntrXval = 2;
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m);
        [Zx,~] = meshgrid(z,y); 
        [~,Zy] = meshgrid(x,z); 
    end
elseif funSlct == 4
    fun = Y + sin((X-3)*pi/4);
    minFunVal   = -1;
    maxValFun   = 7;
    csntrFunVal = 2;
   if (activeCstrX == 1) && (activeCstrY == 0)
       csntrXval = 2;
       z = linspace(minFunVal,maxValFun,m);
       [Z,~] = meshgrid(z,y);                  % level x = C
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m); 
        [~,Z] = meshgrid(x,z);                  % level y = C
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        csntrXval = 2;
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m);
        [Zx,~] = meshgrid(z,y); 
        [~,Zy] = meshgrid(x,z); 
    end
elseif funSlct == 5 
    fun = Y.*sin((X-1)*pi/4);
    minFunVal   = -6;
    maxValFun   = 6;
    csntrFunVal = 1;
    if (activeCstrX == 1) && (activeCstrY == 0)
       csntrXval = 2;
       z = linspace(minFunVal,maxValFun,m);
       [Z,~] = meshgrid(z,y);                  % level x = C
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m); 
        [~,Z] = meshgrid(x,z);                  % level y = C
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        csntrXval = 2;
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m);
        [Zx,~] = meshgrid(z,y); 
        [~,Zy] = meshgrid(x,z); 
    end
elseif funSlct == 6
    fun = Y.*cos((X-1)*pi/4);
    minFunVal   = -6;
    maxValFun   = 6;
    csntrFunVal = 1;
    if (activeCstrX == 1) && (activeCstrY == 0)
       csntrXval = 2;
       z = linspace(minFunVal,maxValFun,m);
       [Z,~] = meshgrid(z,y);                  % level x = C
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m); 
        [~,Z] = meshgrid(x,z);                  % level y = C
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        csntrXval = 2;
        csntrYval = 2;
        z = linspace(minFunVal,maxValFun,m);
        [Zx,~] = meshgrid(z,y); 
        [~,Zy] = meshgrid(x,z); 
    end
end

%% --------------------\\ Optimization Problem \\--------------------------
prob = optimproblem('ObjectiveSense','minimize');
% -------------------\\ Optimization Variables \\--------------------------
y_var   = optimvar('y_var','LowerBound',y_min,'UpperBound',y_max);
x_var   = optimvar('x_var','LowerBound',x_min,'UpperBound',x_max);
f_a     = optimvar('f_a','LowerBound',minFunVal,'UpperBound',maxValFun);


h_u_ij   = optimvar('h_u',n+1,m+1,'Type','integer','LowerBound',0,'UpperBound',1);
h_l_ij   = optimvar('h_l',n+1,m+1,'Type','integer','LowerBound',0,'UpperBound',1);

alpha_ij = optimvar('alpha',n,m,'LowerBound',0,'UpperBound',1);


% Naming variables indexes
indexNames = cell(1, n+1 + m+1);
p = 1;
while p <= n+1 + m+1
    while p <= n+1
        indexNames{p} = append('i_',int2str(p-1));
        p=p+1;
    end
    while p <= n+1 + m+1
        indexNames{p} = append('j_',int2str(p-(n+1+1)));
        p=p+1;
    end
end

for p = 1:2
    if p==1
        h_u_ij.IndexNames{p}     = indexNames(1,1:n+1);
        h_l_ij.IndexNames{p}     = indexNames(1,1:n+1);
        alpha_ij.IndexNames{p} = indexNames(1,2:n+1);
    elseif p==2
        h_u_ij.IndexNames{p}     = indexNames(1,n+1+1 : n+1 + m+1);
        h_l_ij.IndexNames{p}     = indexNames(1,n+1+1 : n+1 + m+1);
        alpha_ij.IndexNames{p} = indexNames(1,n+1+1+1 : n+1 + m+1);
    end
end
%%
% -------------------\\ Optimization Objective \\--------------------------
prob.Objective = f_a;
% -------------------\\ Optimization Constraints \\------------------------

% -----------VARIABLE X
alphaCnstr = optimconstr(n,m);

% SOS3 on binaries h_u and h_l
prob.Constraints.huSOS3a = h_u_ij(1,:) == 0;
prob.Constraints.huSOS3b = h_u_ij(:,1) == 0;

prob.Constraints.huSOS3c = h_u_ij(:,end) == 0;
prob.Constraints.huSOS3d = h_u_ij(end,:) == 0;

prob.Constraints.hlSOS3a = h_l_ij(1,:) == 0;
prob.Constraints.hlSOS3b = h_l_ij(:,1) == 0;

prob.Constraints.hlSOS3c = h_l_ij(:,end) == 0;
prob.Constraints.hlSOS3d = h_l_ij(end,:) == 0;

prob.Constraints.hSOS3 = sum(sum((h_u_ij(2:end-1,2:end-1) + h_l_ij(2:end-1,2:end-1)))) == 1;

% Sum of alphas is 1 (convexity)
prob.Constraints.sumAlpha = sum(sum(alpha_ij)) == 1;

% x value estimation
tempX = 0;
for j = 1 : m
    index_j = append('j_',int2str(j));
    tempX = tempX + y * alpha_ij(:,index_j);
end
prob.Constraints.xValueEst = y_var == tempX;

% y value estimation
tempY = 0;
for i = 1 : n
    index_i = append('i_',int2str(i));
    tempY = tempY + alpha_ij(index_i,:) * x';
end
prob.Constraints.yValueEst = x_var == tempY;

% Value function approximation f^a
tempF = 0;
for i = 1 : n
    for j = 1 : m
        index_i = append('i_',int2str(i));
        index_j = append('j_',int2str(j));
        
        tempF = tempF + alpha_ij(index_i,index_j) * fun(i,j) ;
    end
end
prob.Constraints.functionValueCnstr = f_a == tempF;

% Linear weights constraints
for i = 1 : n
    for j = 1 : m
        index_i = append('i_',int2str(i));
        index_i_prev = append('i_',int2str(i-1));
        index_j = append('j_',int2str(j));
        index_j_prev = append('j_',int2str(j-1));
        alphaCnstr(i,j) = alpha_ij(index_i,index_j) <= h_u_ij(index_i,index_j) + h_l_ij(index_i,index_j)+...
                                                       h_u_ij(index_i,index_j_prev) + h_l_ij(index_i_prev,index_j_prev)+...
                                                       h_u_ij(index_i_prev,index_j_prev) + h_l_ij(index_i_prev,index_j);
    end
end
prob.Constraints.alphaCnstr = alphaCnstr;

% Additional Constraint: fun == c (set level)
prob.Constraints.linearityCnstr = f_a >= csntrFunVal;

if funSlct == 1
    prob.Constraints.linearityCnstr2 = x_var == csntrXval;
elseif funSlct == 2
    prob.Constraints.linearityCnstr2 = y_var == csntrYval;
else
    if (activeCstrX == 1) && (activeCstrY == 0)
        prob.Constraints.linearityCnstr2 = x_var == csntrXval;
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        prob.Constraints.linearityCnstr2 = y_var == csntrYval;
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        prob.Constraints.linearityCnstr2 = x_var == csntrXval;
        prob.Constraints.linearityCnstr3 = y_var == csntrYval;
    end
end


%% --------------------\\ Optimization Solution \\-------------------------
options = optimoptions('intlinprog');
[sol,f_sol] = solve(prob,'Options',options);
%% -----------------------\\ Optimal Solution Plot\\-------------------------
p = surf(X,Y,fun,'FaceAlpha',0.8,'DisplayName','function');xlabel('x');ylabel('y');zlabel('f(x,y)');grid on;hold on;
s = scatter3(sol.x_var,sol.y_var,f_sol,'ro','filled','DisplayName','f_{xy}^*');

s.SizeData = 40;
c1 = mesh(X,Y,csntrFunVal*ones(n,m),'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_1');

if funSlct == 1
    c2 = mesh(csntrXval*ones(n,m),Y,Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
elseif funSlct == 2
    if (activeCstrX == 1) && (activeCstrY == 0)
        c2 = mesh(csntrXval*ones(n,m),Y,Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        c2 = mesh(X,csntrYval*ones(n,m),Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        c2 = mesh(csntrXval*ones(n,m),Y,Zx,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
        c3 = mesh(X,csntrYval*ones(n,m),Zy,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_3');
    else
        c2 = mesh(X,csntrYval*ones(n,m),Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
    end
else
    if (activeCstrX == 1) && (activeCstrY == 0)
        c2 = mesh(csntrXval*ones(n,m),Y,Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
    elseif (activeCstrY == 1) && (activeCstrX == 0)
        c2 = mesh(X,csntrYval*ones(n,m),Z,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
    elseif (activeCstrX == 1) && (activeCstrY == 1)
        c2 = mesh(csntrXval*ones(n,m),Y,Zx,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_2');
        c3 = mesh(X,csntrYval*ones(n,m),Zy,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','none','DisplayName','constraint_3');
    end
end

%% -----------------------\\Validation of solution\\-------------------------
if funSlct == 1
    f_xy = sol.y_var * sol.x_var;
elseif funSlct == 2
    f_xy = sol.y_var * sin((sol.x_var - 3)*pi/4);
elseif funSlct == 3
    f_xy = ((10-sol.y_var).^3).*sin((sol.x_var-1)*pi/4);
elseif funSlct == 4
    f_xy = sol.y_var + sin((sol.x_var-3)*pi/4);
elseif funSlct == 5 
    f_xy = sol.y_var * sin((sol.x_var-1)*pi/4);
elseif funSlct == 6
    f_xy = sol.y_var * cos((sol.x_var-1)*pi/4);
end

f = scatter3(sol.x_var,sol.y_var,f_xy,20,'b*','DisplayName','f(x^*,y^*)');

if funSlct == 1
    legend([p,s,c1,c2,f],{'$f(x,y)$','$\hat{f}_{xy}^*$',['$f \ge',num2str(csntrFunVal),'$'],['$x =',num2str(csntrXval),'$'],'$f(x^*,y^*)$'},'FontSize',12,...
        'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeastoutside');
elseif funSlct == 2
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
        legend([p,s,c1,c2,f],{'$f(x,y)$','$\hat{f}_{xy}^*$',['$f \ge',num2str(csntrFunVal),'$'],['$y =',num2str(csntrYval),'$'],'$f(x^*,y^*)$'},'FontSize',12,...
        'Fontname','Times New Roman','NumColumns',1,'interpreter','latex','Location','northeastoutside');
    end
else
    
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
end