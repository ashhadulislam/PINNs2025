function [E a P0]=F_frac0(input_data, alpha)
% F_frac0 - fitting parameters for model_frac1 
% P=V/C+aV'(1+alpha)+P0 | P=EV+aV'(alpha)+P0; alpha>0
% Copyright (c) Zongwei Li, China 2023

data=load(input_data);%P V' V
[row,column]=size(data);

%fitting
x1=linspace(1,1,row);
X=[data(:,3),data(:,2),x1',x1']';%V V' V'(alpha) 1

%V': alpha-1~(0,1)
%t=1:row;
%f_V=@(t)data(round(t),2);
%X(3,:)=glfdiff9(f_V,t,alpha-1,3);%V'(alpha)
if alpha<1
	X(3,:)=fgl_deriv( alpha, data(:,3), 0.01 );
else
	X(3,:)=fgl_deriv( alpha-1, data(:,2), 0.01 );
end
Pin=data(:,1);
A=inv(X*X')*X*Pin;%[E a P0]
E=A(1);a=A(2);P0=A(3);

end
