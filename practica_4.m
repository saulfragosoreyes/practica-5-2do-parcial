%% Limpia la memoria de variables
clear all
close all
clc

%% Cierra y elimina cualquier objeto de tipo serial 
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%% Creación de un objeto tipo serial
arduino = serial('COM3','BaudRate',9600);
fopen(arduino);
if arduino.status == 'open'
    disp('Arduino conectado correctamente');
else
    disp('No se ha conectado el arduino');
    return
end
%% Configuración de las longitudes del brazo
prompt = 'Introducir el valor de longitud uno:';
L1 = input (prompt);
prompt = 'Introducir el valor de longitud dos:';
L2 = input (prompt);
%% Se establece el número de muestras y el contador para pder utilizarlos en el blucle principal 
numero_muestras = 1000;
y = zeros(1,numero_muestras); 
contador_muestras = 1; 
figure('Name','Serial communication: Matlab + Arduino. TESE-Robótica')
title('SERIAL COMMUNICATION MATLAB + ARDUINO');
xlabel('Número de muestra');
ylabel('Valor');
grid on;
hold on;
%% Definición del punto incial
p1 =[0 0 0];
while 1
    clf
    printAxis();
%% Obtiene los valores del Arduino y mediante la formula se tiene su dimecion de cada uno de sus  grados
    valor_con_offset = fscanf(arduino,'%d,%d´');
    theta1_deg = ((valor_con_offset(1))-512)*130/512;
    theta1_rad = deg2rad(theta1_deg);
    disp('Longitud del primer eslabon en grados:')
    disp(theta1_deg)
    theta2_deg = ((valor_con_offset(2))-512)*130/512;
    theta2_rad = deg2rad(theta2_deg);
    disp('Longitud del primer eslabon en grados:')
    disp(theta2_deg)
    TRz1 = [cos(theta1_rad) -sin(theta1_rad) 0 0; sin(theta1_rad) cos(theta1_rad) 0 0; 0 0 1 0; 0 0 0 1];
    TTx1 = [1 0 0 0; 0 1 0 0; 0 0 1 L1; 0 0 0 1];
    T1 = TRz1*TTx1;
    p2 = T1(1:3,4);
    eje_x_1= T1(1:3,1);
    eje_y_1= T1(1:3,2);
    eje_z_1 =T1(1:3,3);
    line([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'color',[0 0 0],'linewidth',3)
    line([p1(1) eje_x_1(1)],[p1(2) eje_x_1(2)],[p1(3) eje_x_1(3)],'color',[1 0 0],'linewidth',4 )
    line([p1(1) eje_y_1(1)],[p1(2) eje_y_1(2)],[p1(3) eje_y_1(3)],'color',[0 1 0],'linewidth',4 )
    line([p1(1) eje_z_1(1)],[p1(2) eje_z_1(2)],[p1(3) eje_z_1(3)],'color',[0 0 1],'linewidth',4 )
    
    TRy2 = [cos(theta2_rad) 0 -sin(theta2_rad) 0; 0 1 0 0; sin(theta2_rad) 0 cos(theta2_rad) 0; 0 0 0 1];
    TTx2 = [1 0 0 L2; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    T2 = TRy2*TTx2;
    Tf = T1*T2;
    p3 = Tf(1:3,4);
    eje_x_2 = p2+ Tf(1:3,1);
    eje_y_2 = p2+ Tf(1:3,2);
    eje_z_2 = p2+ Tf(1:3,3);
    line([p2(1) p3(1)],[p2(2) p3(2)],[p2(3) p3(3)],'color',[0 0 0],'linewidth',3 )
    line([p2(1) eje_x_2(1)],[p2(2) eje_x_2(2)],[p2(3) eje_x_2(3)],'color',[1 0 0],'linewidth',4 )
    line([p2(1) eje_y_2(1)],[p2(2) eje_y_2(2)],[p2(3) eje_y_2(3)],'color',[0 1 0],'linewidth',4 )
    line([p2(1) eje_z_2(1)],[p2(2) eje_z_2(2)],[p2(3) eje_z_2(3)],'color',[0 0 1],'linewidth',4 )
    view(30,30);
    grid on
    pause(0.01);
end

%% Cierre de puertos 
fclose(arduino);
delete(arduino);
clear all; 


