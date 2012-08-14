clc; close all; clear all 

figure(1)
om1=(pi/180)*[0.000; -00.000;  0.000];
T1=[0.000;  0.000; 160.000];
[omPosit1,TPosit1]=test_posit('view_0001.png',om1,T1);
figure(2)
om2=(pi/180)*[30.000; -00.000;  0.000];
T2=[0.000;  0.000; 160.000];
[omPosit2,TPosit2]=test_posit('view_0002.png',om2,T2);
figure(3)
om3=(pi/180)*[0.000; -30.000;  0.000];
T3=[0.000;  0.000; 160.000];
[omPosit3,TPosit3]=test_posit('view_0003.png',om3,T3);
figure(4)
om4=(pi/180)*[10.000; -20.000;  30.000];
T4=[0.000;  0.000; 160.000];
[omPosit4,TPosit4]=test_posit('view_0004.png',om4,T4);
figure(5)
om5=(pi/180)*[1.000; -3.000;  10.000];
T5=[10.000;  -20.000; 160.000];
[omPosit5,TPosit5]=test_posit('view_0005.png',om5,T5);
figure(6)
om6=(pi/180)*[-11.000; -120.000; 8.000];
T6=[10.000; -20.000; 160.000];
[omPosit6,TPosit6]=test_posit('view_0006.png',om6,T6);


