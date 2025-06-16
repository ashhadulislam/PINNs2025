function [E R I P0]=F2(input_data)
% F2 - fitting parameters for model2 
% P=V/C+RV'+IV''+P0 | P=EC+RV'+IV''+P0
% Copyright (c) Zongwei Li, China 2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' V'' 1
X(3,1)=data(2,2)-data(1,2);%V''
X(3,row)=data(row,2)-data(row-1,2);%V''
for i = 2:row-1
	X(3,i)=(data(i+1,2)-data(i-1,2))/2;
end
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R I P0]
E=A(1);R=A(2);I=A(3);P0=A(4);

end
