function [J] = control_jacobian(h, L)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%% Internal states system
x = h(1);
y = h(2);
z = h(3);
th = h(4);
q1 = h(5);
q2 = h(6);
q3 = h(7);
q4 = h(8);

%% Constants values of the system
a = L(1);
ha = L(2);
l2 = L(3);
l3 = L(4);
l4 = L(5);

%% JAcobian definition 
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

J = [j11, j12, j13, j14, j15, j16;...
     j21, j22, j23, j24, j25, j26;...
     j31, j32, j33, j34, j35, j36];
end

