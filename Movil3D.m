function PLOT_3D=Movil3D(x,y,th)
global R Dim
color1=[75 132 142]/255;
color2=[.75 .75 .75];
color3=[.5 .5 .5];

R0=[cos(th) -sin(th) 0;
    sin(th)  cos(th) 0;
    0        0       1];

TapaSuperior=R0*R.TapaSuperior;
TapaInferior=R0*R.TapaInferior;
TapaDer=R0*R.TapaDer;
TapaIzq=R0*R.TapaIzq;
CuadroBase=R0*R.CuadroBase;

Ruedas=R.TapaRuedas1;
Ruedas2=R.TapaRuedas2;
Ruedas3=R.TapaRuedas3;
%Rueda1
Rueda1_1(1,:)=Ruedas(1,:)+Dim.l1/2-Dim.dr;    Rueda1_1(2,:)=Ruedas(2,:)-Dim.l2/2; Rueda1_1(3,:)=Ruedas(3,:);
Rueda1_2=Rueda1_1;  Rueda1_2(2,:)=Rueda1_2(2,:)-Dim.da;
Rueda1_3(1,:)=Ruedas2(1,:)+Dim.l1/2-Dim.dr;    Rueda1_3(2,:)=Ruedas2(2,:)-Dim.l2/2; Rueda1_3(3,:)=Ruedas2(3,:);
Rueda1_4(1,:)=Ruedas3(1,:)+Dim.l1/2-Dim.dr;    Rueda1_4(2,:)=Ruedas3(2,:)-Dim.l2/2; Rueda1_4(3,:)=Ruedas3(3,:);
Rueda1_5(1,:)=Ruedas(1,:)*.5+Dim.l1/2-Dim.dr;    Rueda1_5(2,:)=Ruedas(2,:)*.5-Dim.l2/2-Dim.da; Rueda1_5(3,:)=(Ruedas(3,:)-Dim.h)*.5+Dim.h;
Rueda1_1=R0*Rueda1_1;
Rueda1_2=R0*Rueda1_2;
Rueda1_3=R0*Rueda1_3;
Rueda1_4=R0*Rueda1_4;
Rueda1_5=R0*Rueda1_5;
%Rueda2
Rueda2_1(1,:)=Ruedas(1,:)+Dim.l1/2-Dim.dr;    Rueda2_1(2,:)=Ruedas(2,:)+Dim.l2/2+Dim.da; Rueda2_1(3,:)=Ruedas(3,:);
Rueda2_2=Rueda2_1;  Rueda2_2(2,:)=Rueda2_2(2,:)-Dim.da;
Rueda2_3(1,:)=Ruedas2(1,:)+Dim.l1/2-Dim.dr;    Rueda2_3(2,:)=Ruedas2(2,:)+Dim.l2/2+Dim.da; Rueda2_3(3,:)=Ruedas2(3,:);
Rueda2_4(1,:)=Ruedas3(1,:)+Dim.l1/2-Dim.dr;    Rueda2_4(2,:)=Ruedas3(2,:)+Dim.l2/2+Dim.da; Rueda2_4(3,:)=Ruedas3(3,:);
Rueda2_5(1,:)=Ruedas(1,:)*.5+Dim.l1/2-Dim.dr;    Rueda2_5(2,:)=Ruedas(2,:)*.5+Dim.l2/2+Dim.da; Rueda2_5(3,:)=(Ruedas(3,:)-Dim.h)*.5+Dim.h;

Rueda2_1=R0*Rueda2_1;
Rueda2_2=R0*Rueda2_2;
Rueda2_3=R0*Rueda2_3;
Rueda2_4=R0*Rueda2_4;
Rueda2_5=R0*Rueda2_5;
%Rueda3
Rueda3_1(1,:)=Ruedas(1,:)-Dim.l1/2+Dim.dr;    Rueda3_1(2,:)=Ruedas(2,:)+Dim.l2/2+Dim.da; Rueda3_1(3,:)=Ruedas(3,:);
Rueda3_2=Rueda3_1;  Rueda3_2(2,:)=Rueda3_2(2,:)-Dim.da;
Rueda3_3(1,:)=Ruedas2(1,:)-Dim.l1/2+Dim.dr;    Rueda3_3(2,:)=Ruedas2(2,:)+Dim.l2/2+Dim.da; Rueda3_3(3,:)=Ruedas2(3,:);
Rueda3_4(1,:)=Ruedas3(1,:)-Dim.l1/2+Dim.dr;    Rueda3_4(2,:)=Ruedas3(2,:)+Dim.l2/2+Dim.da; Rueda3_4(3,:)=Ruedas3(3,:);
Rueda3_5(1,:)=Ruedas(1,:)*.5-Dim.l1/2+Dim.dr;    Rueda3_5(2,:)=Ruedas(2,:)*.5+Dim.l2/2+Dim.da; Rueda3_5(3,:)=(Ruedas(3,:)-Dim.h)*.5+Dim.h;

Rueda3_1=R0*Rueda3_1;
Rueda3_2=R0*Rueda3_2;
Rueda3_3=R0*Rueda3_3;
Rueda3_4=R0*Rueda3_4;
Rueda3_5=R0*Rueda3_5;
%Rueda4
Rueda4_1(1,:)=Ruedas(1,:)-Dim.l1/2+Dim.dr;    Rueda4_1(2,:)=Ruedas(2,:)-Dim.l2/2; Rueda4_1(3,:)=Ruedas(3,:);
Rueda4_2=Rueda4_1;  Rueda4_2(2,:)=Rueda4_2(2,:)-Dim.da;
Rueda4_3(1,:)=Ruedas2(1,:)-Dim.l1/2+Dim.dr;    Rueda4_3(2,:)=Ruedas2(2,:)-Dim.l2/2; Rueda4_3(3,:)=Ruedas2(3,:);
Rueda4_4(1,:)=Ruedas3(1,:)-Dim.l1/2+Dim.dr;    Rueda4_4(2,:)=Ruedas3(2,:)-Dim.l2/2; Rueda4_4(3,:)=Ruedas3(3,:);
Rueda4_5(1,:)=Ruedas(1,:)*.5-Dim.l1/2+Dim.dr;    Rueda4_5(2,:)=Ruedas(2,:)*.5-Dim.l2/2-Dim.da; Rueda4_5(3,:)=(Ruedas(3,:)-Dim.h)*.5+Dim.h;

Rueda4_1=R0*Rueda4_1;
Rueda4_2=R0*Rueda4_2;
Rueda4_3=R0*Rueda4_3;
Rueda4_4=R0*Rueda4_4;
Rueda4_5=R0*Rueda4_5;

PLOT_3D(1)=patch(TapaSuperior(1,:)+x,TapaSuperior(2,:)+y,TapaSuperior(3,:),color1);
PLOT_3D(2)=patch(TapaInferior(1,:)+x,TapaInferior(2,:)+y,TapaInferior(3,:),color1);
PLOT_3D(3)=patch(TapaDer(1,:)+x,TapaDer(2,:)+y,TapaDer(3,:),color1);
PLOT_3D(4)=patch(TapaIzq(1,:)+x,TapaIzq(2,:)+y,TapaIzq(3,:),color1);
PLOT_3D(5)=patch(CuadroBase(1,:)+x,CuadroBase(2,:)+y,CuadroBase(3,:),'k');

PLOT_3D(6)=patch(Rueda1_1(1,:)+x,Rueda1_1(2,:)+y,Rueda1_1(3,:),color2);
PLOT_3D(7)=patch(Rueda1_2(1,:)+x,Rueda1_2(2,:)+y,Rueda1_2(3,:),color2);
PLOT_3D(8)=patch(Rueda1_3(1,:)+x,Rueda1_3(2,:)+y,Rueda1_3(3,:),color3);
PLOT_3D(9)=patch(Rueda1_4(1,:)+x,Rueda1_4(2,:)+y,Rueda1_4(3,:),color3);
PLOT_3D(10)=patch(Rueda1_5(1,:)+x,Rueda1_5(2,:)+y,Rueda1_5(3,:),color3);

PLOT_3D(11)=patch(Rueda2_1(1,:)+x,Rueda2_1(2,:)+y,Rueda2_1(3,:),color2);
PLOT_3D(12)=patch(Rueda2_2(1,:)+x,Rueda2_2(2,:)+y,Rueda2_2(3,:),color2);
PLOT_3D(13)=patch(Rueda2_3(1,:)+x,Rueda2_3(2,:)+y,Rueda2_3(3,:),color3);
PLOT_3D(14)=patch(Rueda2_4(1,:)+x,Rueda2_4(2,:)+y,Rueda2_4(3,:),color3);
PLOT_3D(15)=patch(Rueda2_5(1,:)+x,Rueda2_5(2,:)+y,Rueda2_5(3,:),color3);

PLOT_3D(16)=patch(Rueda3_1(1,:)+x,Rueda3_1(2,:)+y,Rueda3_1(3,:),color2);
PLOT_3D(17)=patch(Rueda3_2(1,:)+x,Rueda3_2(2,:)+y,Rueda3_2(3,:),color2);
PLOT_3D(18)=patch(Rueda3_3(1,:)+x,Rueda3_3(2,:)+y,Rueda3_3(3,:),color3);
PLOT_3D(19)=patch(Rueda3_4(1,:)+x,Rueda3_4(2,:)+y,Rueda3_4(3,:),color3);
PLOT_3D(20)=patch(Rueda3_5(1,:)+x,Rueda3_5(2,:)+y,Rueda3_5(3,:),color3);

PLOT_3D(21)=patch(Rueda4_1(1,:)+x,Rueda4_1(2,:)+y,Rueda4_1(3,:),color2);
PLOT_3D(22)=patch(Rueda4_2(1,:)+x,Rueda4_2(2,:)+y,Rueda4_2(3,:),color2);
PLOT_3D(23)=patch(Rueda4_3(1,:)+x,Rueda4_3(2,:)+y,Rueda4_3(3,:),color3);
PLOT_3D(24)=patch(Rueda4_4(1,:)+x,Rueda4_4(2,:)+y,Rueda4_4(3,:),color3);
PLOT_3D(25)=patch(Rueda4_5(1,:)+x,Rueda4_5(2,:)+y,Rueda4_5(3,:),color3);

% axis equal;xlabel('X');ylabel('Y');zlabel('Z')