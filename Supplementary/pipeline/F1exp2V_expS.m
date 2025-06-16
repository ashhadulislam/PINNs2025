function [E R a b P0]=F1exp2V_expS(input_data,x,y)
% F1exp2V_expS - fitting parameters for model_1exp2V_expS
% P=V/C+RV'+a*V*e^e^(x*V)+b*e^(y*V')+P0 
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1',x1']';%V V' exp(V) exp(V') 1
X(3,:)=exp(exp(x*data(:,3)));
%X(3,:)=X(3,:).*data(:,3)';
X(4,:)=exp(y*data(:,2));
%X(4,:)=X(4,:).*data(:,2)';

Pin=data(:,1);
A=pinv(X*X')*X*Pin;%[E R a b P0]
E=A(1);R=A(2);a=A(3);b=A(4);P0=A(5);

end
