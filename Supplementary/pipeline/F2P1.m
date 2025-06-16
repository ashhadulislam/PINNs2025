function [E R I a P0]=F2P1(input_data)
% F2P1 - fitting parameters for modelF2P1 
% P=V/C+RV'+IV''+aP'+P0 | P=EC+RV'+IV''+aP'+P0
% Copyright (c) Zongwei Li, China 2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1',x1']';%V V' V'' P' 1
%V''
X(3,1)=data(2,2)-data(1,2);%V''
X(3,row)=data(row,2)-data(row-1,2);%V''
for i = 2:row-1
	X(3,i)=(data(i+1,2)-data(i-1,2))/2;
end

%P'
X(4,1)=data(2,1)-data(1,1);
X(4,row)=data(row,1)-data(row-1,1);
for i = 2:row-1
	X(4,i)=(data(i+1,1)-data(i-1,1))/2;
end

Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E R I a P0]
E=A(1);R=A(2);I=A(3);a=A(4);P0=A(5);

end
