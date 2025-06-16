function [E R a b P0]=F1VxSy(input_data, pow_x, pow_y)
% F1VxSy - fitting parameters for model_1VxSy
% P=V/C+RV'+a*V^x+b*(V')^y+P0 | P=EC+RV'+a*V^x+b*(V')^y+P0
% Copyright (c) Zongwei Li, China  2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1',x1']';%V V' V^x V'^y 1
X(3,:)=data(:,3).^pow_x;
X(4,:)=data(:,2).^pow_y;
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R a b P0]
E=A(1);R=A(2);a=A(3);b=A(4);P0=A(5);

end
