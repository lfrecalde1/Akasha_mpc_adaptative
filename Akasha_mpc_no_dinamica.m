%% Adaptative mpc applied in a redundant mobile manipulator%%

%% Clear variables of the simulation
clc, clear all, close all;

%% Time defintion variable
t_s = 0.1;
t_final = 60;
t = (0:t_s:t_final);

%% Constan values of the kinematic system
a  = 0.175;            
ha = 0.375;
l2 = 0.275;            
l3 = 0.275;          
l4 = 0.15;

%% Vector of constants of the system 
L  = [a;...
      ha;...
      l2;...
      l3;...
      l4];
  
%% Initial conditions definitions
%% Mobile Platform definition
x(1) = 4; 
y(1) = 2;
th(1) = 0*pi/180; 
%% Initial mesurements arm
q1 = 40*pi/180;
q2 = 45*pi/180;
q3 = -45*pi/180;
q4 = 60*pi/180;

%% Defintion initial velocities of the system 
u = 0;
w = 0;
q1p = 0;
q2p = 0; 
q3p = 0;
q4p = 0;

%% General vector of dynamic velocities of the system
v=[u(1);w(1);q1p(1);q2p(1);q3p(1)];

%% Forward Kinematics
xs(1) = x(1) + a*cos(th)+cos(q1+th)*(l2*cos(q2)+l3*cos(q2+q3)+l4*cos(q2+q3+q4));
ys(1) = y(1) + a*sin(th)+sin(q1+th)*(l2*cos(q2)+l3*cos(q2+q3)+l4*cos(q2+q3+q4));
zs(1) = ha + l2*sin(q2)+l3*sin(q2+q3)+l4*sin(q2+q3+q4);

h_aux = [xs;ys;zs];

H = [xs(1);...
     ys(1);...
     zs(1);...
     th(1);...
     q1;...
     q2;...
     q3;...
     q4];
 
%% Generalized vector og the internal states of the system
h = [xs(1);...
     ys(1);...
     zs(1);...
     th(1);...
     q1;...
     q2;...
     q3;...
     q4];

%% Desired trajectory of the system
hxd = 3.5*cos(0.1*t)+1.75;    hxd_p = -3.5*0.1*sin(0.1*t);      
hyd = 3.5*sin(0.1*t)+1.75;    hyd_p =  3.5*0.1*cos(0.1*t);     
hzd = 0.15*sin(0.5*t)+0.6;     hzd_p =  0.15*0.5*cos(0.5*t); 


%% Desired internal states fo the system
theta_d = 0*pi/180*ones(1,length(t));
q1d =  0*pi/180*ones(1,length(t));
q2d = 60*pi/180*ones(1,length(t));
q3d =-40*pi/180*ones(1,length(t));
q4d = 0*pi/180*ones(1,length(t));

%% General vector of the desired internal states
qd = [theta_d;q1d;q2d;q3d;q4d];

%% General vector of the desired trajectory and velocities of the system
hd = [hxd;hyd;hzd];
hdp = [hxd_p;hyd_p;hzd_p];

%% General vector od desires states of the sytem
HD = [hd;qd];
%% Controller gains
k1 = 1;
k2 = 1;

%% Definicion del horizonte de prediccion
N = 15; 

%% Definicion de los limites de las acciondes de control
bounded = [2.5; -2.5; 2.5; -2.5; 2.5; -2.5; 2.5; -2.5; 2.5; -2.5; 2.5; -2.5];
%% Definicion del vectro de control inicial del sistema
vc = zeros(N,6);
H0 = repmat(H,1,N+1)'; 

%% MPC controller initialitation
[f, solver, args] = mpc_akasha(bounded, N, L, t_s);
%% Simulation loop
for k = 1:1:length(t)-N
    tic
    %% Generation of the vector of errors of the system 
    he(:, k) =  hd(:,k) - h_aux(1:3,k);
    qe(:, k) = qd(2:5,k) - h(5:8,k);
    %% Control law generation
    %control  =  inverse_kinematics(h_aux(:, k), h(:,k), hd(:,k), hdp(:, k), qd(:,k), k1, k2, L);
    [H0, control] = NMPC(h_aux(:,k), h(:,k), HD, k, H0, vc, args, solver ,N);
    
    %% Control vector fomrmation
    u_c(k) = control(1, 1);
    w_c(k) = control(1, 2);
    q1p_c(k) = control(1, 3);
    q2p_c(k) = control(1, 4);
    q3p_c(k) = control(1, 5);
    q4p_c(k) = control(1, 6);
    vref(:,k) = [u_c(k);w_c(k);q1p_c(k);q2p_c(k);q3p_c(k);q4p_c(k)];
    
    %% System integration
    h(:,k+1) = system_akasha(h(:,k), [vref(1:5,k);q4p_c(k)], t_s, L);
    
    %% Proyection base
    xp = u_c(k)*cos(h(4,k+1))-a*w_c(k)*sin(h(4,k+1));
    yp = u_c(k)*sin(h(4,k+1))+a*w_c(k)*cos(h(4,k+1));
    
    %% Forward kinematics mobile robot
    x(k+1) =  t_s*xp + x(k);   
    y(k+1) =  t_s*yp + y(k);
    th(k+1) = t_s*w_c(k) + th(k);
    
    %% End effector point
    xs(k+1) = x(k+1) + a*cos(th(k+1))+cos(h(5,k+1)+th(k+1))*(l2*cos(h(6,k+1))+l3*cos(h(6,k+1)+h(7,k+1))+l4*cos(h(6,k+1)+h(7,k+1)+h(8,k+1)));
    ys(k+1) = y(k+1) + a*sin(th(k+1))+sin(h(5,k+1)+th(k+1))*(l2*cos(h(6,k+1))+l3*cos(h(6,k+1)+h(7,k+1))+l4*cos(h(6,k+1)+h(7,k+1)+h(8,k+1)));
    zs(k+1) = ha + l2*sin(h(6,k+1))+l3*sin(h(6,k+1)+h(7,k+1))+l4*sin(h(6,k+1)+h(7,k+1)+h(8,k+1));
    
    %% End effector location vector
    h_aux(:,k+1) = [xs(k+1);ys(k+1);zs(k+1)];
    
    vc = [control(2:end,:);control(end,:)];
    H0 = [H0(2:end,:);H0(end,:)];
    toc
end


%% Square error calculation
error_x =  trapz(t_s,he(1,:).^2)
error_y =  trapz(t_s,he(2,:).^2)
error_z =  trapz(t_s,he(3,:).^2)

close all; paso=1; 
%% Parametros del cuadro de animacion
figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 8 3]);
luz = light;
luz.Color=[0.65,0.65,0.65];
luz.Style = 'infinite';
%b) Dimenciones del Robot
    DimensionesMovil();
    DimensionesManipulador(a,ha);

%c) Dibujo del Robot    
    G1=Movil3D(x(1),y(1),th(1));
    G2=Manipulador3D(x(1),y(1),th(1),h(5,1),h(6,1),h(7,1),h(8,1));

    plot3(h_aux(1,1),h_aux(2,1),h_aux(3,1),'--','Color',[56,171,217]/255,'linewidth',1.5);hold on,grid on   
    plot3(hxd(1),hyd(1),hzd(1),'Color',[32,185,29]/255,'linewidth',1.5);
    
axis equal; 
for k = 1:10:length(t)-N
    drawnow
    delete(G1);
    delete(G2);
 
    G1=Movil3D(x(1,k),y(1,k),th(1,k));
    G2=Manipulador3D(x(1,k),y(1,k),th(1,k),h(5,k),h(6,k),h(7,k),h(8,k));
    plot3(hxd(1:k),hyd(1:k),hzd(1:k),'Color',[32,185,29]/255,'linewidth',1.5);
    plot3(h_aux(1,1:k),h_aux(2,1:k),h_aux(3,1:k),'--','Color',[56,171,217]/255,'linewidth',1.5);
    legend({'$\mathbf{h}$','$\mathbf{h}_{des}$'},'Interpreter','latex','FontSize',11,'Location','northwest','Orientation','horizontal');
    legend('boxoff')
    title('$\textrm{Movement Executed by the Mobile Manipulator}$','Interpreter','latex','FontSize',11);
    xlabel('$\textrm{X}[m]$','Interpreter','latex','FontSize',9); ylabel('$\textrm{Y}[m]$','Interpreter','latex','FontSize',9);zlabel('$\textrm{Z}[m]$','Interpreter','latex','FontSize',9);
    
%     axis([-1 5 -1 5 0 1]);
end
print -dpng SIMULATION_1
print -depsc SIMULATION_1

%% Parameters fancy plots
% define plot properties
lw = 1.5; 
lwV = 2; 
fontsizeLabel = 9; 
fontsizeLegend = 10;
fontsizeTicks = 9;
fontsizeTitel = 9;
sizeX = 900; 
sizeY = 350; 

% color propreties
C1 = [246 170 141]/255;
C2 = [51 187 238]/255;
C3 = [0 153 136]/255;
C4 = [238 119 51]/255;
C5 = [204 51 17]/255;
C6 = [238 51 119]/255;
C7 = [187 187 187]/255;
C8 = [80 80 80]/255;
C9 = [140 140 140]/255;
C10 = [0 128 255]/255;
C11 = [234 52 89]/255;
C12 = [39 124 252]/255;
C13 = [40 122 125]/255;
%C14 = [86 215 219]/255;
C14 = [252 94 158]/255;
C15 = [244 171 39]/255;
C16 = [100 121 162]/255;
C17 = [255 0 0]/255;

%% New color palette
P1 = [211, 235, 205]/255;
P2 = [174, 219, 206]/255;
P3 = [131, 154, 168]/255;
P4 = [99, 86, 102]/255;

P5 = [33, 36, 61]/255;
P6 = [255, 124, 124]/255;
P7 = [255, 208, 130]/255;
P8 = [136, 225, 242]/255;

%% Plot control errors of the sytem 
figure('Position', [10 10 sizeX sizeY])
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8.5 11]);
set(gcf, 'PaperPositionMode', 'manual');

subplot(2,1,1)
plot(t(1,1:length(he)),he(1,:),'-.','Color',C9,'LineWidth',lw); hold on
plot(t(1,1:length(he)),he(2,:),'-','Color',C11,'LineWidth',lw);
plot(t(1,1:length(he)),he(3,:),'--','Color',C12,'LineWidth',lw);
grid minor;
grid minor;
set(gca,'ticklabelinterpreter','latex',...
        'fontsize',fontsizeTicks)
ylabel('$[m]$','interpreter','latex','fontsize',fontsizeLabel)
title({'(a)'},'fontsize',fontsizeTitel,'interpreter','latex')
legend({'$\tilde{h}_x$','$\tilde{h}_y$','$\tilde{h}_z$'},'interpreter','latex','fontsize',fontsizeLegend, 'Orientation','horizontal','Location', 'Best')
legend('boxoff')
%plot(t,ul,'-','Color',C2,'LineWidth',lw);
grid minor;

subplot(2,1,2)
plot(t(1,1:length(qe)),qe(1,:),'-.','Color',P1,'LineWidth',lw); hold on
plot(t(1,1:length(qe)),qe(2,:),'-','Color',P2,'LineWidth',lw);
plot(t(1,1:length(qe)),qe(3,:),'--','Color',P3,'LineWidth',lw);
plot(t(1,1:length(qe)),qe(4,:),':','Color',P4,'LineWidth',lw);
grid minor;

set(gca,'ticklabelinterpreter','latex',...
        'fontsize',fontsizeTicks)
xlabel('$\textrm{Time}[s]$','interpreter','latex','fontsize',fontsizeLabel)
ylabel('$[rad]$','interpreter','latex','fontsize',fontsizeLabel)
title({'(b)'},'fontsize',fontsizeTitel,'interpreter','latex')
% set(gca,'Xticklabel',[])
legend({'$\tilde{q}_1$','$\tilde{q}_2$','$\tilde{q}_3$','$\tilde{q}_4$'},'interpreter','latex','fontsize',fontsizeLegend, 'Orientation','horizontal','Location', 'Best')
legend('boxoff')

%% Plot control actions of the system
figure('Position', [10 10 sizeX sizeY])
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8.5 11]);
set(gcf, 'PaperPositionMode', 'manual');

subplot(2,1,1)
plot(t(1,1:length(u_c)),u_c,'-.','Color',C9,'LineWidth',lw); hold on
plot(t(1,1:length(w_c)),w_c,'-','Color',C11,'LineWidth',lw);
grid minor;
grid minor;
set(gca,'ticklabelinterpreter','latex',...
        'fontsize',fontsizeTicks)
ylabel('$[m/s],[rad/s]$','interpreter','latex','fontsize',fontsizeLabel)
title({'(a)'},'fontsize',fontsizeTitel,'interpreter','latex')
legend({'$\mu_{c}$','$\omega_{c}$'},'interpreter','latex','fontsize',fontsizeLegend, 'Orientation','horizontal','Location', 'Best')
legend('boxoff')
%plot(t,ul,'-','Color',C2,'LineWidth',lw);
grid minor;

subplot(2,1,2)
plot(t(1,1:length(q1p_c)),q1p_c,'-.','Color',P5,'LineWidth',lw); hold on
plot(t(1,1:length(q2p_c)),q2p_c,'-','Color',P6,'LineWidth',lw);
plot(t(1,1:length(q3p_c)),q3p_c,'--','Color',P7,'LineWidth',lw);
plot(t(1,1:length(q4p_c)),q4p_c,':','Color',P8,'LineWidth',lw);
grid minor;

set(gca,'ticklabelinterpreter','latex',...
        'fontsize',fontsizeTicks)
xlabel('$\textrm{Time}[s]$','interpreter','latex','fontsize',fontsizeLabel)
ylabel('$[rad/s]$','interpreter','latex','fontsize',fontsizeLabel)
title({'(b)'},'fontsize',fontsizeTitel,'interpreter','latex')
% set(gca,'Xticklabel',[])
legend({'$\dot{q}_{1c}$','$\dot{q}_{2c}$','$\dot{q}_{3c}$','$\dot{q}_{4c}$'},'interpreter','latex','fontsize',fontsizeLegend, 'Orientation','horizontal','Location', 'Best')
legend('boxoff')
