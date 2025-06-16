function [E R a P0]=F1Vx(input_data, pow)
% F1Ex - fitting parameters for model_1Vx
% P=V/C+RV'+a*V^x+P0 | P=EC+RV'+a*V^x+P0
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' V^x 1
X(3,:)=data(:,3).^pow;
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R a P0]
E=A(1);R=A(2);a=A(3);P0=A(4);

end
