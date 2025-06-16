function [E R a P0]=F1VexpV(input_data,pow_x)
% F1VexpV - fitting parameters for model_1expV
% P=V/C+RV'+a*V*e^(pow_x*V)+P0 | P=EC+RV'+a*V*e^(pow_x*V)+P0
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' exp(V) 1
X(3,:)=exp(pow_x*data(:,3));
X(3,:)=X(3,:).*data(:,3)';
Pin=data(:,1);
A=pinv(X*X')*X*Pin;%[E R a P0]
E=A(1);R=A(2);a=A(3);P0=A(4);

end
