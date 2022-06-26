function [control] = inverse_kinematics(h, hd, hdp, k1, k2, L)
%UNTITLED6 Summary of this function goes here
%% Error vector definiton
he = hd - h(1:3);
J = control_jacobian(h, L);
K1 = k1*eye(length(he));
K2 = k2*eye(length(he));

control = pinv(J)*(hdp+K2*tanh(pinv(K2)*K1*he));
control =  control';
end

