function [E R a P0]=F_frac1(input_data, alpha)
% F_frac1 - fitting parameters for model_frac1 
% P=V/C+RV'+aV(alpha)+P0 | P=EV+RV'+aV(alpha)+P0; alpha~(1,2)
% Copyright (c) Zongwei Li, China 2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' V'(alpha) 1

%V': alpha-1~(1,2);V: alpha~(1~2)
t=1:row;
f_V=@(t)data(round(t),2);
%X(3,:)=glfdiff9(f_V,t,alpha-1,3);%V'(alpha)
%X(3,:)=fgl_deriv( alpha-1, data(:,2), 0.01 );%too slow
X(3,:)=glfdiff9(f_V,t,alpha);%V'(alpha)
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R a P0]
E=A(1);R=A(2);a=A(3);P0=A(4);

end
