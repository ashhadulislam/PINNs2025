function [E R b P0]=F1Sy(input_data, pow)
% F1Sy - fitting parameters for model_1Sy
% P=V/C+RV'+b*(V')^y+P0 | P=EC+RV'+b*(V')^y+P0
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' V'^y 1
X(3,:)=data(:,2).^pow;
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R b P0]
E=A(1);R=A(2);b=A(3);P0=A(4);

end
