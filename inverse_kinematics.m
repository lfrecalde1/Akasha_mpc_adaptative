function [control] = inverse_kinematics(h, q, hd, hdp, qd, k1, k2, L)
%UNTITLED6 Summary of this function goes here
%% Error vector definiton
he = hd - h(1:3);
J = control_jacobian(q, L);
K1 = k1*eye(length(he));
K2 = k2*eye(length(he));

%% Control general
% control = pinv(J)*(hdp+K2*tanh(pinv(K2)*K1*he));
% control =  control';

%% Control secundary objetives
null_space = (eye(6)-J'*inv(J*J')*J);
qe = qd - q(5:8);
vh = [0;0;qe];
control = J'*inv(J*J')*(hdp+K2*tanh(pinv(K2)*K1*he)) + null_space*vh;
control = control';
end

