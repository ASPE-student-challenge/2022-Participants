clc;clear all; close all
data=xlsread('Alvarez_example_data.xlsx');
rawy=data(:,1);rawx=data(:,2);rawz=data(:,3);
y=rawy(747:27864);
x=rawx(747:27864);
z=rawz(747:27864);

figure(1)
T = delaunay(y,x);
h=trisurf(T,y,x,z);
shading interp;colormap('jet');
xlabel('y(mm)');ylabel('x (mm)');zlabel('z (V)')

[l0,m0,z0] = fn_planefit(x,y,z);
zplanerem=z-(z0+l0*x+m0*y);

figure(2)
h=trisurf(T,y,x,zplanerem);
shading interp;colormap('jet');
xlabel('y (mm)');ylabel('x (mm)');zlabel('z (V)')
c=colorbar; lim = caxis; c.Title.String ='z (V)'; c.Label.FontSize = 12;

function [l0,m0,z0] = fn_planefit(x,y,z)
%this function takes an array of (x,y) points and fits a plane

n = length(x);

A1 = [ones(n,1),x,y]';
A2 = [x,y,ones(n,1)];
b = z;

A1A2 = A1* A2;
Ab = A1 * b;

plane = A1A2 \ Ab;

l0 = plane(1);
m0 = plane(2);
z0 = plane(3);
end
