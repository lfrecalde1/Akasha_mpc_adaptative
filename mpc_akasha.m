function [f,solver,args] = mpc_akasha(bounded, N, L, ts)

addpath('/home/fer/casadi-linux-matlabR2014b-v3.4.5');
import casadi.*;

%% Definicion de las restricciones en las acciones de control
ul_max = bounded(1); 
ul_min = bounded(2);

w_max = bounded(3); 
w_min = bounded(4);

q1_max = bounded(5); 
q1_min = bounded(6);

q2_max = bounded(7); 
q2_min = bounded(8);

q3_max = bounded(9); 
q3_min = bounded(10);

q4_max = bounded(11); 
q4_min = bounded(12);

%% Generacion de las variables simbolicas de los estados del sistema
x = SX.sym('x'); 
y = SX.sym('y');
z = SX.sym('z');
th = SX.sym('th');
q1 = SX.sym('q1');
q2 = SX.sym('q2');
q3 = SX.sym('q3');
q4 = SX.sym('q4');
%% Definicion de cuantos estados en el sistema
states = [x;y;z;th;q1;q2;q3;q4];

n_states = length(states);

%% Generacion de las variables simbolicas de las acciones del control del sistema
u_ref = SX.sym('u_ref');
w_ref = SX.sym('w_ref');
q1p_ref = SX.sym('q1p_ref');
q2p_ref = SX.sym('q2p_ref');
q3p_ref = SX.sym('q3p_ref');
q4p_ref = SX.sym('q4p_ref');

%% Defincion de cuantas acciones del control tiene el sistema
controls = [u_ref;w_ref;q1p_ref;q2p_ref;q3p_ref;q4p_ref]; 
n_control = length(controls);


%% Definicion de los las constantes dl sistema
a = L(1);
ha = L(2);
l2 = L(3);
l3 = L(4);
l4 = L(5);


%% Defincion del sistema pero usando espacios de estados todo el sistema de ecuaciones
j11 = cos(th);
j12 = -sin(q1+th)*(l3*cos(q2+q3)+l2*cos(q2)+l4*cos(q2+q3+q4))-a*sin(th);
j13 = -sin(q1+th)*(l3*cos(q2+q3)+l2*cos(q2)+l4*cos(q2+q3+q4));
j14 = -cos(q1+th)*(l3*sin(q2+q3)+l2*sin(q2)+l4*sin(q2+q3+q4));
j15 = -cos(q1+th)*(l3*sin(q2+q3)+l4*sin(q2+q3+q4));
j16 = -l4*sin(q2+q3+q4)*cos(q1+th);

j21 = sin(th);
j22 = cos(q1+th)*(l3*cos(q2+q3)+l2*cos(q2)+l4*cos(q2+q3+q4))+a*cos(th);
j23 = cos(q1+th)*(l3*cos(q2+q3)+l2*cos(q2)+l4*cos(q2+q3+q4));
j24 = -sin(q1+th)*(l3*sin(q2+q3)+l2*sin(q2)+l4*sin(q2+q3+q4));
j25 = -sin(q1+th)*(l3*sin(q2+q3)+l4*sin(q2+q3+q4));
j26 = -l4*sin(q2+q3+q4)*sin(q1+th);

j31 = 0;
j32 = 0;
j33 = 0;
j34 = l3*cos(q2+q3)+l2*cos(q2)+l4*cos(q2+q3+q4);
j35 = l3*cos(q2+q3)+l4*cos(q2+q3+q4);
j36 = l4*cos(q2+q3+q4);

j41 = 0;
j42 = 1;
j43 = 0;
j44 = 0;
j45 = 0;
j46 = 0;

j51 = 0;
j52 = 0;
j53 = 1;
j54 = 0;
j55 = 0;
j56 = 0;

j61 = 0;
j62 = 0;
j63 = 0;
j64 = 1;
j65 = 0;
j66 = 0;

j71 = 0;
j72 = 0;
j73 = 0;
j74 = 0;
j75 = 1;
j76 = 0;

j81 = 0;
j82 = 0;
j83 = 0;
j84 = 0;
j85 = 0;
j86 = 1;

J = [j11, j12, j13, j14, j15, j16;...
     j21, j22, j23, j24, j25, j26;...
     j31, j32, j33, j34, j35, j36;...
     j41, j42, j43, j44, j45, j46;...
     j51, j52, j53, j54, j55, j56;...
     j61, j62, j63, j64, j65, j66;...
     j71, j72, j73, j74, j75, j76;...
     j81, j82, j83, j84, j85, j86];

%% Definicion de kas funciones del sistema
X = SX.sym('X',n_states,(N+1));
U = SX.sym('U',n_control,N);
P = SX.sym('P',n_states + N*(n_states));


rhs=(J*controls);
f = Function('f',{states,controls},{rhs}); 

%% Vector que representa el problema de optimizacion
g = [];  % restricciones de estados del problema  de optimizacion

%%EMPY VECTOR ERRORS
he_space = [];
h_internal = [];

%% EMPY VECTOR CONTROL VALUES
u = [];


g = [g;X(:,1)-P(1:n_states)]; % initial condition constraints


%% Definicon del bucle para optimizacion a los largo del tiempo
for k = 1:N
    
    st = X(:,k);  con = U(:,k);
    %X(4,k) = full(wrapToPi(X(4,k)));

    %% Funcion costo a minimizar 
    he_space = [he_space;X(1:3,k)-P(n_states*k+1:n_states*k+3)];
%     h_internal = [h_internal;X((8+1):(8+obs_num),k)];
    h_internal = [h_internal;X(5:8,k)-P(n_states*k+5:n_states*k+8)];

    u = [u;con];
    
    
    %% Actualizacion del sistema usando Euler runge kutta
    st_next = X(:,k+1);
    k1 = f(st, con);   % new 
    k2 = f(st + ts/2*k1, con); % new
    k3 = f(st + ts/2*k2, con); % new
    k4 = f(st + ts*k3, con); % new
    st_next_RK4 = st +ts/6*(k1 +2*k2 +2*k3 +k4); % new 
    
    %% Restricciones del sistema se =basan en el modelo del sistema
    g = [g;st_next-st_next_RK4]; 
end

% Cost final 
Q = 1*eye(size(he_space,1));
Q_internal = 0.1*eye(size(h_internal,1));
R = 0.001*eye(size(u,1));


% FINAL COST
obj = he_space'*Q*he_space + u'*R*u + h_internal'*Q_internal*h_internal;

OPT_variables = [reshape(X,n_states*(N+1),1);reshape(U,n_control*N,1)];

nlprob = struct('f', obj, 'x', OPT_variables, 'g', g, 'p', P);

opts = struct;
opts.ipopt.max_iter = 100;
opts.ipopt.print_level =0;%0,3
opts.print_time = 0;
opts.ipopt.acceptable_tol =1e-6;
opts.ipopt.acceptable_obj_change_tol = 1e-4;

solver = nlpsol('solver', 'ipopt', nlprob,opts);

args = struct;

args.lbg(1:n_states*(N+1)) = 0;  %-1e-20  %Equality constraints
args.ubg(1:n_states*(N+1)) = 0;  %1e-20   %Equality constraints
 
args.lbx(1:n_states:n_states*(N+1),1) = -inf; %state x lower bound
args.ubx(1:n_states:n_states*(N+1),1) = inf;  %state x upper bound

args.lbx(2:n_states:n_states*(N+1),1) = -inf; %state y lower bound
args.ubx(2:n_states:n_states*(N+1),1) = inf;  %state y upper bound

args.lbx(3:n_states:n_states*(N+1),1) = -inf; %state z lower bound
args.ubx(3:n_states:n_states*(N+1),1) = inf;  %state z upper bound

args.lbx(4:n_states:n_states*(N+1),1) = -inf; %state theta lower bound
args.ubx(4:n_states:n_states*(N+1),1) = inf;  %state theta upper bound

args.lbx(5:n_states:n_states*(N+1),1) = -inf; %state q1 lower bound
args.ubx(5:n_states:n_states*(N+1),1) = inf;  %state q1 upper bound

args.lbx(6:n_states:n_states*(N+1),1) = -inf; %state q2 lower bound
args.ubx(6:n_states:n_states*(N+1),1) = inf;  %state q2 upper bound

args.lbx(7:n_states:n_states*(N+1),1) = -inf; %state q3 lower bound
args.ubx(7:n_states:n_states*(N+1),1) = inf;  %state q3 upper bound

args.lbx(8:n_states:n_states*(N+1),1) = -inf; %state q4 lower bound
args.ubx(8:n_states:n_states*(N+1),1) = inf;  %state q4 upper bound


%% Definicion de las restricciones de las acciones de control del sistema
args.lbx(n_states*(N+1)+1:6:n_states*(N+1)+6*N,1) = ul_min;  %
args.ubx(n_states*(N+1)+1:6:n_states*(N+1)+6*N,1) = ul_max;  %

args.lbx(n_states*(N+1)+2:6:n_states*(N+1)+6*N,1) = w_min;  %
args.ubx(n_states*(N+1)+2:6:n_states*(N+1)+6*N,1) = w_max;  %

args.lbx(n_states*(N+1)+3:6:n_states*(N+1)+6*N,1) = q1_min;  %
args.ubx(n_states*(N+1)+3:6:n_states*(N+1)+6*N,1) = q1_max;  %

args.lbx(n_states*(N+1)+4:6:n_states*(N+1)+6*N,1) = q2_min;  %
args.ubx(n_states*(N+1)+4:6:n_states*(N+1)+6*N,1) = q2_max;  %

args.lbx(n_states*(N+1)+5:6:n_states*(N+1)+6*N,1) = q3_min;  %
args.ubx(n_states*(N+1)+5:6:n_states*(N+1)+6*N,1) = q3_max;  %

args.lbx(n_states*(N+1)+6:6:n_states*(N+1)+6*N,1) = q4_min;  %
args.ubx(n_states*(N+1)+6:6:n_states*(N+1)+6*N,1) = q4_max;  %
end