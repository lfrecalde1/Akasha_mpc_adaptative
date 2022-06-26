%% Adaptative mpc applied in a redundant mobile manipulator%%

%% Clear variables of the simulation
clc, clear all, close all;

%% Time defintion variable
t_s = 0.1;
t_final = 40;
t = (0:t_s:t_final);

%% Constan values of the kinematic system

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