clc;clear all; close all
data=xlsread('concavemirror_example.xlsx');
rawy=data(:,1);rawx=data(:,2);rawz=data(:,3);
y=rawy(1:33750);
x=rawx(1:33750);
z=-rawz(1:33750);

figure(1)
T = delaunay(y,x);
h=trisurf(T,y,x,z);
shading interp;colormap('jet');
xlabel('y(mm)');ylabel('x (mm)');zlabel('z (V)')
c=colorbar; lim = caxis; c.Title.String ='z (V)'; c.Label.FontSize = 12;

Points = [x y z];
%% Fitting a sphere to raw data
[Center,Radius] = sphereFit(Points)

[n,~] = size(Points);
for i = 1:n
z_calculated(i,1) = -(sqrt(Radius^2-(x(i)-Center(1,1))^2-(y(i)-Center(1,2))^2) - Center(1,3));
end
% z_calculated=-z_calculated;

Residue=z-z_calculated;

figure(2)
h=trisurf(T,y,x,Residue);
shading interp;colormap('jet');
xlabel('y(mm)');ylabel('x (mm)');zlabel('z (V)')
c=colorbar; lim = caxis; c.Title.String ='residue (V)'; c.Label.FontSize = 12;


function [Center,Radius] = sphereFit(X)
% fits a sphere to a collection of data using a closed form for the solution (opposed to using an array the size of the data set). 
% Minimizes Sum((x-xc)^2+(y-yc)^2+(z-zc)^2-r^2)^2
% x,y,z are the data, xc,yc,zc are the sphere's center, and r is the radius
% Assumes that points are not in a singular configuration, real numbers
% Input: X: n x 3 matrix of cartesian data
% Author: Alan Jennings, University of Dayton

A=[mean(X(:,1).*(X(:,1)-mean(X(:,1)))), ...
    2*mean(X(:,1).*(X(:,2)-mean(X(:,2)))), ...
    2*mean(X(:,1).*(X(:,3)-mean(X(:,3)))); ...
    0, ...
    mean(X(:,2).*(X(:,2)-mean(X(:,2)))), ...
    2*mean(X(:,2).*(X(:,3)-mean(X(:,3)))); ...
    0, ...
    0, ...
    mean(X(:,3).*(X(:,3)-mean(X(:,3))))];
A=A+A.';
B=[mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,1)-mean(X(:,1))));...
    mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,2)-mean(X(:,2))));...
    mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,3)-mean(X(:,3))))];
Center=(A\B).';
Radius=sqrt(mean(sum([X(:,1)-Center(1),X(:,2)-Center(2),X(:,3)-Center(3)].^2,2)));
end
