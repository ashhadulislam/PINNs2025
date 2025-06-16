function [E R P0]=F1(input_data)
% F1 - fitting parameters for model1 
% P=V/C+RV'+P0 | P=EC+RV'+P0
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1']';%V V' 1
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R P0]
E=A(1);R=A(2);P0=A(3);

end
