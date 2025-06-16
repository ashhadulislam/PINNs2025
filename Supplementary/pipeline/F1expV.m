function [E R a P0]=F1expV(input_data,pow)
% F1expV - fitting parameters for model_1expV
% P=V/C+RV'+a*e^V+P0 | P=EC+RV'+a*e^V+P0
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' V^x 1
X(3,:)=exp(pow*data(:,3));
Pin=data(:,1);
A=pinv(X*X')*X*Pin;%[E R a P0]
E=A(1);R=A(2);a=A(3);P0=A(4);

end
