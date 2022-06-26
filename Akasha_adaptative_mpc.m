%% Adaptative mpc applied in a redundant mobile manipulator%%

%% Clear variables of the simulation
clc, clear all, close all;

%% Time defintion variable
t_s = 0.1;
t_final = 40;
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
x = 4; 
y = 2;
th = 0*pi/180; 
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
%% System movil oonly for animation
hm = [x;y;th];

%% Forward Kinematics
x = x + a*cos(th)+cos(q1+th)*(l2*cos(q2)+l3*cos(q2+q3)+l4*cos(q2+q3+q4));
y = y + a*sin(th)+sin(q1+th)*(l2*cos(q2)+l3*cos(q2+q3)+l4*cos(q2+q3+q4));
z = ha + l2*sin(q2)+l3*sin(q2+q3)+l4*sin(q2+q3+q4);

%% Generalized vector og the internal states of the system
h = [x;...
     y;...
     z;...
     th;...
     q1;...
     q2;...
     q3;...
     q4];

%% Desired trajectory of the system
hxd = 3.5*cos(0.05*t)+1.75;    hxd_p = -3.5*0.05*sin(0.05*t);      
hyd = 3.5*sin(0.05*t)+1.75;    hyd_p =  3.5*0.05*cos(0.05*t);     
hzd = 0.15*sin(0.5*t)+0.6;     hzd_p =  0.15*0.5*cos(0.5*t); 

%% General vector of the desired trajectory and velocities of the system
hd = [hxd;hyd;hzd];
hdp = [hxd_p;hyd_p;hzd_p];

%% Controller gains
k1 = 1;
k2 = 1;
%% Simulation loop
for k = 1:1:length(t)
    %% Generation of the vector of errors of the system 
    he(:, k) =  hd(:,k) - h(1:3,k);
    
    %% Control law generation
    control  =  inverse_kinematics(h(:, k), hd(:,k), hdp(:, k), k1, k2, L);
    
    %% Control vector fomrmation
    u_c(k) = control(1, 1);
    w_c(k) = control(1, 2);
    q1p_c(k) = control(1, 3);
    q2p_c(k) = control(1, 4);
    q3p_c(k) = control(1, 5);
    q4p_c(k) = control(1, 6);
    vref = [u_c(k);w_c(k);q1p_c(k);q2p_c(k);q3p_c(k);q4p_c(k)];
    
    %% System Evolution
    h(:,k+1) = system_akasha(h(:,k), vref, t_s, L);
    hm(:,k+1) = system_movil(hm(:,k), vref, t_s, L);
end

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
    G1=Movil3D(hm(1,1),hm(2,1),h(4,1));
    G2=Manipulador3D(hm(1,1),hm(2,1),h(4,1),h(5,1),h(6,1),h(7,1),h(8,1));

    plot3(h(1,1),h(2,1),h(3,1),'--','Color',[56,171,217]/255,'linewidth',1.5);hold on,grid on   
    plot3(hxd(1),hyd(1),hzd(1),'Color',[32,185,29]/255,'linewidth',1.5);
    
axis equal; 
for k = 1:10:length(t)
    drawnow
    delete(G1);
    delete(G2);
 
    G1 = Movil3D(hm(1,k),hm(2,k),h(4,k));
    G2 = Manipulador3D(hm(1,k),hm(2,k),h(4,k),h(5,k),h(6,k),h(7,k),h(8,k));
    plot3(hxd(1:k),hyd(1:k),hzd(1:k),'Color',[32,185,29]/255,'linewidth',1.5);
    plot3(h(1,1:k),h(2,1:k),h(3,1:k),'--','Color',[56,171,217]/255,'linewidth',1.5);
    legend({'$\mathbf{h}$','$\mathbf{h}_{des}$'},'Interpreter','latex','FontSize',11,'Location','northwest','Orientation','horizontal');
    legend('boxoff')
    title('$\textrm{Movement Executed by the Mobile Manipulator}$','Interpreter','latex','FontSize',11);
    xlabel('$\textrm{X}[m]$','Interpreter','latex','FontSize',9); ylabel('$\textrm{Y}[m]$','Interpreter','latex','FontSize',9);zlabel('$\textrm{Z}[m]$','Interpreter','latex','FontSize',9);
    
%     axis([-1 5 -1 5 0 1]);
end
print -dpng SIMULATION_1
print -depsc SIMULATION_1