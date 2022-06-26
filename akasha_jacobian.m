function [J] = akasha_jacobian(h, L)
%UNTITLED3 Summary of this function goes here
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
    
end

