function [E R a b P0]=F_frac1exp2V(input_data, alpha, beta)
% F_frac1exp2V - fitting parameters for mix model
% P=V/C+RV'+aV'(alpha)+b*e^e^(beta*V)+P0 | P=EV+RV'+aV'(alpha)+b*e^e^(beta*V)+P0; alpha~(1,2)
% Copyright (c) Zongwei Li, China 2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1',x1']';%V V' V'(alpha) 1

%V': alpha-1~(0,1)
t=1:row;
f_V=@(t)data(round(t),2);
%X(3,:)=glfdiff9(f_V,t,alpha-1,3);%V'(alpha)
X(3,:)=fgl_deriv( alpha-1, data(:,2), 0.01 );
X(4,:)=exp(exp(beta*data(:,3)));%e^e^V

Pin=data(:,1);
A=pinv(X*X')*X*Pin;%[E R a b P0]
E=A(1);R=A(2);a=A(3);b=A(4);P0=A(5);

end
