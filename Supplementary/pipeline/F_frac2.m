function [E R a b P0]=F_frac1(input_data, alpha, beta)
% F_frac1 - fitting parameters for model_frac1 
% P=V/C+RV'+aV(alpha)+P0 | P=EV+RV'+aV(alpha)+P0; alpha~(1,2)
% Copyright (c) Zongwei Li, China 2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1',x1']';%V V' V(alpha) V(beta) 1

%0<alpha<beta
t=1:row;
f_V=@(t)data(round(t),2);
X(3,:)=glfdiff9(f_V,t,alpha);%V(alpha)
X(4,:)=glfdiff9(f_V,t,beta);%V(beta)
Pin=data(:,1);
A=pinv(X*X')*X*Pin;%[E R a b P0]
E=A(1);R=A(2);a=A(3);b=A(4);P0=A(5);

end
