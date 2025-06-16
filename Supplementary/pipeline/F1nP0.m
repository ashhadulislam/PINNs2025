function [E R]=F1nP0(input_data)
% F1 - fitting parameters for model1 
% P=V/C+RV'| P=EC+RV'
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2)]';%V V'
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R]
E=A(1);R=A(2);

end
