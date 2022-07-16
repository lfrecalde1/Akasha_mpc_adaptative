function Dinamica = AKASHA_DINAMICA(vref,v,q,ts)

if nargin<4
   ts=0.1; 
end

% a) Velocidades de la plataforma m�vil y del brazo rob�tico
     us = v(1);
     ws = v(2);
     q1ps = v(3);
     q2ps = v(4);
     q3ps = v(5);

% b) Estados de la plataforma m�vil y del brazo rob�tico

     ths = q(1);
     q1s = q(2);
     q2s = q(3);
     q3s = q(4);
  
% c) Par�metros Din�micos del AKASHA
     m=30;r=0.15;R=0.25;a=0.195;
     m2=3;m3=4;
     l2=0.275;l3=0.375;g=9.81;Ra=4.6;
     Kp=4;Kd=0.63;Ka=584;Kb=0.05;
     Kpt=4;Kpr=2;Kdt=0.63;Kdr=0.28;
     Kpa=584;Kpb=0.05;Rpa=4.6;
   
     C1=Kdt/Kpt;
     C2=Rpa*r*(m+m2+m3)/(2*Kpa*Kpt);
     C3=Rpa*m2*r/(2*Kpa*Kpt);
     C4=Rpa*m3*r/(2*Kpa*Kpt);
     C5=Rpa*m2*r/(2*Kpa*Kpr*R);
     C6=Rpa*m3*r/(2*Kpa*Kpr*R);
     C7=Kdr/Kpr;
     C8=Rpa*r*(m+m2+m3)/(2*Kpa*Kpr*R);
    
     C9=Ra*m2/(Ka*Kp);
     C10=Ra*m3/(Ka*Kp);
     C11=Kd/(Kp);
     C12=Kpb/(Kpt*r)+.95;
     C13=Kpb*R/(Kpr*r)+.95;
     C14=Kb/(Kp)+.95;
     C15=Ra*g*m2/(Ka*Kp);
     C16=Ra*g*m3/(Ka*Kp);


% d) Matriz de Inercia
     M11 = C1+C2;
     M12 = -l2*C3*cos(q2s)*sin(q1s)-C4*(l2*cos(q2s)*sin(q1s)+l3*cos(q2s+q3s)*sin(q1s));
     M13 = -l2*C3*cos(q2s)*sin(q1s)-C4*(l2*cos(q2s)*sin(q1s)+l3*cos(q2s+q3s)*sin(q1s));
     M14 = -l2*C3*sin(q2s)*cos(q1s)-C4*(l2*sin(q2s)*cos(q1s)+l3*sin(q2s+q3s)*cos(q1s));
     M15 = -C4*l3*sin(q2s+q3s)*cos(q1s);
     M21 = -l2*C3*cos(q2s)*sin(q1s)-C4*(l2*cos(q2s)*sin(q1s)+l3*cos(q2s+q3s)*sin(q1s));
     M22 = C7+C8*(1+2*a^2)+C5*l2*cos(q2s)*(l2*cos(q2s)+2*a*cos(q1s)+a*cos(ths+q1s)*cos(ths)+a*sin(ths+q1s)*sin(ths))+...
           C6*(l3^2*cos(q2s+q3s)^2+l2^2*cos(q2s)^2+2*l2*l3*cos(q2s+q3s)*cos(q2s)+2*a*l3*cos(q2s+q3s)*cos(q1s)+2*a*l2*cos(q2s)*cos(q1s)...
           +a*l3*cos(q2s+q3s)*cos(q1s)+a*l2*cos(q2s)*cos(q1s));
     M23 = C5*(l2^2*cos(q2s)^2+a*l2*cos(q1s)*cos(q2s))+...
           C6*(l3^2*cos(q2s+q3s)^2+l2^2*cos(q2s)^2+a*l3*cos(q2s+q3s)*cos(q1s)+a*l2*cos(q2s)*cos(q1s)+2*l2*l3*cos(q2s+q3s)*cos(q2s));
     M24 = -C5*a*l2*sin(q2s)*sin(q1s)-C6*(a*l2*sin(q2s)*sin(q1s)+a*l3*sin(q2s+q3s)*sin(q1s));
     M25 = -C6*a*l3*sin(q2s+q3s)*sin(q1s);
     M31 = -l2*C9*cos(q2s)*sin(q1s)-C10*(l2*cos(q2s)*sin(q1s)+l3*cos(q2s+q3s)*sin(q1s));
     M32 = C9*(l2^2*cos(q2s)^2+2*a*l2*cos(q1s)*cos(q2s))+...
           C10*(l3^2*cos(q2s+q3s)^2+l2^2*cos(q2s)^2+2*a*l3*cos(q2s+q3s)*cos(q1s)+2*a*l2*cos(q2s)*cos(q1s)+2*l2*l3*cos(q2s+q3s)*cos(q2s));
     M33 = C11+C9*l2^2*cos(q2s)^2+C10*(l3^2*cos(q2s+q3s)^2+l2^2*cos(q2s)^2+2*l2*l3*cos(q2s+q3s)*cos(q2s));
     M34 = 0; M35 = 0;
     M41 = -l2*C9*sin(q2s)*cos(q1s)-C10*(l2*sin(q2s)*cos(q1s)+l3*sin(q2s+q3s)*cos(q1s));
     M42 = -C9*2*a*l2*sin(q2s)*sin(q1s)-C10*(2*a*l2*sin(q2s)*sin(q1s)+2*a*l3*sin(q2s+q3s)*sin(q1s));
     M43 = 0;
     M44 = C11+C9*l2^2+C10*(l2^2+l3^2+2*l2*l3*cos(q3s));
     M45 = C10*l3*(l3+l2*cos(q3s));
     M51 = -C10*l3*sin(q2s+q3s)*cos(q1s);
     M52 = -C10*2*a*l3*sin(q2s+q3s)*sin(q1s);
     M53 = 0;M54=C10*l3*(l3+l2*cos(q3s));
     M55 = C11+C10*l3^2;
    
    
     M = [M11 M12 M13 M14 M15;
          M21 M22 M23 M24 M25; 
          M31 M32 M33 M34 M35;
          M41 M42 M43 M44 M45; 
          M51 M52 M53 M54 M55];
 
% e) Matriz de Fuerzas Centr�petas y de Coriolis
     Cs11 = C12;
     Cs12 = -2*a*C2*ws+C3*(l2*sin(q1s)*sin(q2s)*q2ps-l2*cos(q1s)*cos(q2s)*ws-l2*cos(q1s)*cos(q2s)*q1ps)+C4*(l3*sin(q1s)*sin(q2s+q3s)*q3ps+...
            (l3*sin(q1s)*sin(q2s+q3s)+l2*sin(q1s)*sin(q2s))*q2ps-(l2*cos(q1s)*cos(q2s)+l3*cos(q2s+q3s)*cos(q1s))*q1ps-(l2*cos(q1s)*cos(q2s)+l3*cos(q2s+q3s)*cos(q1s))*ws);
     Cs13 = C3*(l2*sin(q1s)*sin(q2s)*q2ps+l2*cos(q1s)*cos(q2s)*q1ps-l2*cos(q1s)*cos(q2s)*ws)+C4*(l3*sin(q1s)*sin(q2s+q3s)*q3ps+...
            (l3*sin(q1s)*sin(q2s+q3s)+l2*sin(q1s)*sin(q2s))*q2ps-(l2*cos(q1s)*cos(q2s)+l3*cos(q2s+q3s)*cos(q1s))*q1ps-(l2*cos(q1s)*cos(q2s)+l3*cos(q2s+q3s)*cos(q1s))*ws);
     Cs14 = C3*(l2*sin(q1s)*sin(q2s)*ws+l2*sin(q1s)*sin(q2s)*q1ps-l2*cos(q1s)*cos(q2s)*q2ps)+C4*((l2*sin(q1s)*sin(q2s)+l3*sin(q2s+q3s)*sin(q1s))*ws+...
            (l2*sin(q1s)*sin(q2s)+ l3*sin(q2s+q3s)*sin(q1s))*q1ps-(l3*cos(q1s)*cos(q2s+q3s)+l2*cos(q1s)*cos(q2s))*q2ps-l3*cos(q1s)*cos(q2s+q3s)*q3ps);
     Cs15 = C4*(l3*sin(q2s+q3s)*sin(q1s)*ws+...
            l3*sin(q2s+q3s)*sin(q1s)*q1ps-l3*cos(q1s)*cos(q2s+q3s)*q2ps-l3*cos(q1s)*cos(q2s+q3s)*q3ps);
     
     Cs21 = C8*ws+(C5*(l2*cos(q1s)*cos(ths)*cos(2*q1s+q2s)+2*l2*sin(q1s+ths)*cos(q2s)*sin(ths))+...
            C6*(l2*cos(q2s)*cos(ths)*cos(q1s-q2s)+l3*cos(q2s+q3s)*cos(ths)*cos(q1s-q2s)+l3*cos(q2s+q3s)*sin(ths+q1s)*sin(ths)))*ws;
     Cs22 = C12+C5*(a*l2*cos(q2s)*sin(q1s)*(ws+q1ps)+(l2^2*cos(q2s)*sin(q2s)+a*l2*cos(q1s)*sin(q2s))*q2ps)+...
            C6*((a*l2*cos(q2s)*sin(q1s)+a*l3*cos(q2s+q3s)*sin(q1s))*(ws+q1ps)+(a*l2*cos(q1s)*sin(q2s)...
            +l2^2*cos(q2s)*sin(q2s)+l2*l3*cos(q2s+q3s)*sin(q2s))*q2ps+(l2*l3*sin(q2s+q3s)*cos(q2s)+l3^2*cos(q2s+q3s)*sin(q2s+q3s)+a*l3*sin(q2s+q3s)*cos(q1s))*(q2ps+q3ps));
     Cs23 = -C5*(a*l2*cos(q2s)*sin(q1s)*(ws+q1ps)+(l2^2*cos(q2s)*sin(q2s)+a*l2*cos(q1s)*sin(q2s))*q2ps)-...
            C6*((a*l2*cos(q2s)*sin(q1s)+a*l3*cos(q2s+q3s)*sin(q1s))*(ws+q1ps)+(a*l2*cos(q1s)*sin(q2s)...
            +l2^2*cos(q2s)*sin(q2s)+l2*l3*cos(q2s+q3s)*sin(q2s))*q2ps+(l2*l3*sin(q2s+q3s)*cos(q2s)+l3^2*cos(q2s+q3s)*sin(q2s+q3s)+a*l3*sin(q2s+q3s)*cos(q1s))*(q2ps+q3ps));
     Cs24 = -C5*((l2^2*cos(q2s)*sin(q2s)+a*l2*cos(q1s)*sin(q2s)*(ws+q1ps)+a*l2*sin(q1s)*cos(q2s))*(q2ps+q3ps))-...
            C6*((l2^2*cos(q2s)*sin(q2s)+l3^2*cos(q2s+q3s)*sin(q2s+q3s)+a*l3*sin(q2s+q3s)*cos(q1s)+l2*l3*cos(q2s+q3s)*sin(q2s)+...
            l2*l3*sin(q2s+q3s)*cos(q2s)+a*l2*cos(q1s)*sin(q2s))*(ws+q1ps)+(a*l2*sin(q1s)*cos(q2s)+a*l3*sin(q1s)*cos(q2s+q3s))*(q2ps+q3ps));
     Cs25 = -C6*((l2*l3*sin(q2s+q3s)*cos(q2s+q3s)+a*l3*sin(q2s+q3s)*cos(q1s)+l2*l3*sin(q2s+q3s)*cos(q2s)))*(ws+q1ps)+...
            (a*l3*sin(q1s)*cos(q2s+q3s))*(q2ps+q3ps);
    
     Cs31 = C9*l2*cos(q2s)*cos(q1s)*ws+C10*(l2*cos(q1s)*cos(q2s)+l3*cos(q2s+q3s)*cos(q1s))*ws;
     Cs32 = C9*(-l2^2/2*sin(2*q2s)*q2ps+(a*l2*sin(q1s+q2s)+a*l2*sin(q1s-q2s))*ws)+...
            C10*((a*l2*sin(q1s+q2s)+a*l2*sin(q1s-q2s)-a*l3/4*sin(q2s-q1s+q3s)+3*a*l3/4*sin(q1s-q2s-q3s)+a*l3*sin(q1s+q2s+q3s))*ws-...
            (l2^2/2*sin(2*q2s)+l3^2/2*sin(2*q2s+2*q3s)+l2*l3*sin(2*q2s+q3s))*q2ps-(l3^2/2*sin(2*q2s+2*q3s)+l2*l3/2*sin(q3s)+l2*l3/2*sin(2*q2s+q3s))*q3ps);
     Cs33 = C14-C9*l2^2/2*sin(2*q2s)*q2ps-...
            C10*((l2^2/2*sin(2*q2s)+l3^2/2*sin(2*q2s+2*q3s)+l2*l3*sin(2*q2s+q3s))*q2ps+(l2*l3*sin(q2s+q3s)*cos(q2s)+l3^2*sin(q2s+q3s)*cos(q2s+q3s))*q3ps);
     Cs34 = C9*l2^2/2*sin(2*q2s)*(ws+q1ps)+ C10*((l2^2/2*sin(2*q2s)+l3^2/2*sin(2*q2s+2*q3s)+l2*l3*sin(2*q2s+q3s)))*(ws+q1ps);
     Cs35 = C10*((l3*sin(q2s+q3s)*cos(q2s+q3s)+l2*sin(q2s+q3s)*cos(q2s)))*(ws+q1ps);
    
     Cs41 = -C9*l2*sin(q1s)*sin(q2s)*ws-C10*(l2*sin(q1s)*sin(q2s)+l3*sin(q1s)*sin(q2s+q3s))*ws;
     Cs42 = C9*(l2^2/2*sin(2*q2s)*(ws+q1ps)+(a*l2*sin(q1s+q2s)-a*l2*sin(q1s-q2s))*ws)+...
            C10*((a*l2*sin(q1s+q2s)-a*l2*sin(q1s-q2s)+a*l3/4*sin(q2s-q1s+q3s)-3*a*l3/4*sin(q1s-q2s-q3s)+a*l3*sin(q1s+q2s+q3s))*ws+...
            (l2^2/2*sin(2*q2s)+l3^2/2*sin(2*q2s+2*q3s)+l2*l3*sin(2*q2s+q3s))*(ws+q1ps));
     Cs43 = C9*(l2^2/2*sin(2*q2s)*(ws+q1ps))+...
            C10*(l2^2/2*sin(2*q2s)+l3^2/2*sin(2*q2s+2*q3s)+l2*l3*sin(2*q2s+q3s))*(ws+q1ps);
     Cs44 = C14-C10*l2*l3*sin(q3s)*q3ps;
     Cs45 = -C10*l2*l3*sin(q3s)*(q2ps+q3ps);
    
     Cs51 = -C10*l3*sin(q2s+q3s)*sin(q1s)*ws;
     Cs52 = C10*l3*sin(q2s+q3s)*((2*a*cos(q1s)+l2*cos(q2s)+l3*cos(q2s+q3s))*ws+(a*cos(q1s)+l3*cos(q2s+q3s))*q1ps);
     Cs53 = C10*l3*sin(q2s+q3s)*(l3*cos(q2s+q3s)+l2*cos(q2s))*(ws+q1ps);
     Cs54 = C10*l2*l3*sin(q3s)*q2ps;
     Cs55 = C14;
    
     C = [Cs11 Cs12 Cs13 Cs14 Cs15;
          Cs21 Cs22 Cs23 Cs24 Cs25; 
          Cs31 Cs32 Cs33 Cs34 Cs35;
          Cs41 Cs42 Cs43 Cs44 Cs45; 
          Cs51 Cs52 Cs53 Cs54 Cs55];
    
% f) Vector gravitacional    
    G4 = C15*l2*cos(q2s)+C16*(l3*cos(q2s+q3s)+l2*cos(q2s));
    G5 = C16*l3*cos(q2s+q3s);
    G = [0;0;0;G4;G5];
  
% g) Modelo Din�mico AKASHA (Vref = M*vp + C*v + G);  vref=[uref(k) wref(k) q1pref(k) q2pref(k) q3pref(k)]';
    vp = inv(M)*(vref-C*v-G);
    v = v+vp*ts;
    
    us = v(1);
    ws = v(2);
    q1ps = v(3);
    q2ps = v(4);
    q3ps = v(5);
    v_1 = [us ws q1ps q2ps q3ps]';
    
    Dinamica = [v_1];
end