function DimensionesMovil(escala)
if nargin<1
   escala=1;    
end
global R Dim
%Movil
Dim.l1=.5;
Dim.l2=.5;
l3=.075;
h1=.05;
Dim.h2=.25;
r=.12;
Dim.dr=0.075;
Dim.da=0.06;
Dim.a=0.175;
Dim.h=(h1+Dim.h2)/2;
R.TapaSuperior=[Dim.l1/2 Dim.l1/2+l3*cosd(45) Dim.l1/2+l3*cosd(45) Dim.l1/2 -Dim.l1/2 -Dim.l1/2-l3*cosd(45) -Dim.l1/2-l3*cosd(45) -Dim.l1/2;
    -Dim.l2/2 -Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2 -Dim.l2/2 -Dim.l2/2;
    Dim.h2 Dim.h2-l3*sind(45) Dim.h2-l3*sind(45) Dim.h2 Dim.h2 Dim.h2-l3*sind(45) Dim.h2-l3*sind(45) Dim.h2]*escala;
R.TapaInferior=[Dim.l1/2 Dim.l1/2+l3*cosd(45) Dim.l1/2+l3*cosd(45) Dim.l1/2 -Dim.l1/2 -Dim.l1/2-l3*cosd(45) -Dim.l1/2-l3*cosd(45) -Dim.l1/2;
    -Dim.l2/2 -Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2 -Dim.l2/2 -Dim.l2/2;
    h1 h1+l3*sind(45) h1+l3*sind(45) h1 h1 h1+l3*sind(45) h1+l3*sind(45) h1]*escala;
R.TapaDer=[Dim.l1/2 Dim.l1/2+l3*cosd(45) Dim.l1/2+l3*cosd(45) Dim.l1/2+l3*cosd(45) Dim.l1/2+l3*cosd(45) Dim.l1/2 ...
    -Dim.l1/2 -Dim.l1/2-l3*cosd(45)  -Dim.l1/2-l3*cosd(45) -Dim.l1/2;
    -Dim.l2/2 -Dim.l2/2 Dim.l2/2 Dim.l2/2 -Dim.l2/2 -Dim.l2/2  -Dim.l2/2 -Dim.l2/2 -Dim.l2/2 -Dim.l2/2;
    h1 h1+l3*sind(45) h1+l3*sind(45) Dim.h2-l3*sind(45) Dim.h2-l3*sind(45) Dim.h2 ...
    Dim.h2 Dim.h2-l3*sind(45) h1+l3*sind(45) h1]*escala;
R.TapaIzq=[Dim.l1/2 Dim.l1/2+l3*cosd(45) Dim.l1/2+l3*cosd(45) Dim.l1/2 ...
    -Dim.l1/2 -Dim.l1/2-l3*cosd(45)  -Dim.l1/2-l3*cosd(45) -Dim.l1/2-l3*cosd(45) -Dim.l1/2-l3*cosd(45) -Dim.l1/2;
    Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2 Dim.l2/2  -Dim.l2/2 -Dim.l2/2 Dim.l2/2 Dim.l2/2;
    h1 h1+l3*sind(45)  Dim.h2-l3*sind(45) Dim.h2 ...
    Dim.h2 Dim.h2-l3*sind(45) Dim.h2-l3*sind(45) h1+l3*sind(45) h1+l3*sind(45) h1]*escala;
R.CuadroBase=[[Dim.l1/7 Dim.l1/7 -Dim.l1/7 -Dim.l1/7]+Dim.a;-Dim.l1/7 Dim.l1/7 Dim.l1/7 -Dim.l1/7;Dim.h2 Dim.h2 Dim.h2 Dim.h2]*escala;
%Ruedas
paso=20;
R.TapaRuedas1=[r*cosd(0:paso:360);r*cosd(0:paso:360)*0;r*sind(0:paso:360)+Dim.h]*escala;
paso=20;
R.TapaRuedas2=[r*cosd(0:paso:180) r*cosd(170:-paso:-10);r*cosd(0:paso:180)*0 r*cosd(0:paso:180)*0-Dim.da;...
    [r*sind(0:paso:180) r*sind(170:-paso:-10)]+Dim.h]*escala;
R.TapaRuedas3=[r*cosd(180:paso:360) r*cosd(350:-paso:170);r*cosd(0:paso:180)*0 r*cosd(0:paso:180)*0-Dim.da;...
    [r*sind(180:paso:360) r*sind(350:-paso:170)]+Dim.h]*escala;

Dim.l1=Dim.l1*escala;
Dim.l2=Dim.l2*escala;
Dim.h2=Dim.h2*escala;
Dim.dr=Dim.dr*escala;
Dim.da=Dim.da*escala;
Dim.a=Dim.a*escala;


% R.texture = imread('roda.jpg');
% R.texture2 = imread('roda2.jpg');