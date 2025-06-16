function [best_model] = FS_all ()
%FS_all: perform fitting and simulation on all types of models
global alpha
global beta
global E
global R
global I
global a
global b
global P0
global simin
global input_data
global data
global TestOut
global x
global y


disp(input_data)
[row,column]=size(data);
t=1:row;% total data points
t2=t/100;%sampling cycle = 10ms (0.01s)
best_model='model1';
pow_min=2;
pow_max=11;
ssr_matrix=zeros(pow_max,pow_max);

load_system('model1')
load_system('model2')
load_system('model2P1')
load_system('model_1Vx')
load_system('model_1Sy')
load_system('model_1VxSy')
load_system('model_frac1')
load_system('model_frac2')
load_system('model_1VexpV')
load_system('model_1Vexp2V')
load_system('model_1Vexp3V')
load_system('model_frac1Vexp2V')

%-----------------P=V/C+RV'+P0 | P=EV+RV'+P0-----------------------
tic
%fitting
[E R P0]=F1(input_data);
if min([E R P0])>0 %Routh-Hurwitz criterion
	%Simulation
	input=data(:,1)-P0;
	simin=[t2;input']';
	set_param('model1','StopTime','length(data)/100');
	TestOut = sim('model1','ReturnWorkspaceOutputs','on');
	%Evaluation
	out = TestOut.simout.Data(:);
	out(1)=[];
	Correlation=corr(data(:,3),out);
	diff=data(:,3)-out;
	ssr=dot(diff,diff);
	BIC=row*log(ssr)+log(row)*3;
	RMSE=sqrt(ssr/row);
	disp(['model_1 : SSR=', num2str(ssr),', BIC=', num2str(BIC), ', Correlation=', num2str(Correlation),', RMSE=',num2str(RMSE)])
	best_BIC=BIC;
	ssr_matrix(1,1)=ssr;
end
toc
%-----------------P=V/C+RV'+IV''+P0 | P=EC+RV'+IV''+P0-----------------------
%fitting<1s
%{
tic
[E R I P0]=F2(input_data);
if min([E R I P0])>0 %Routh-Hurwitz criterion
	%Simulation
	input=data(:,1)-P0;
	simin=[t2;input']';
	set_param('model2','StopTime','length(data)/100');
	TestOut = sim('model2','ReturnWorkspaceOutputs','on');
	%Evaluation
	out = TestOut.simout.Data(:);
	out(1)=[];
	Correlation=corr(data(:,3),out);
	diff=data(:,3)-out;
	ssr=dot(diff,diff);
	BIC=row*log(ssr)+log(row)*4;
	RMSE=sqrt(ssr/row);
	if (BIC<best_BIC)
		best_model='model1';
		best_BIC=BIC;
		best_ssr=ssr;
	end
	disp(['model_2 : SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation),', RMSE=',num2str(RMSE)])
end
toc
%}
%-----------------P=V/C+RV'+P0+a*V^x-----------------------
tic
for x = pow_min:pow_max
	%fitting
	[E R a P0]=F1Vx(input_data,x);
	if min([E R a P0])>0 %Routh-Hurwitz criterion, a>0 represents a positive correlation between E and V
		%Simulation
		input=data(:,1)-P0;
		simin=[t2;input']';
		set_param('model_1Vx','StopTime','length(data)/100');
		TestOut = sim('model_1Vx','ReturnWorkspaceOutputs','on');
		%Evaluation
		out = TestOut.simout.Data(:);
		out(1)=[];
		Correlation=corr(data(:,3),out);
		diff=data(:,3)-out;
		ssr=dot(diff,diff);
		BIC=row*log(ssr)+log(row)*5;
		RMSE=sqrt(ssr/row);
		if (BIC<best_BIC)
			best_model=['model_1Vx ',num2str(x)];
			best_BIC=BIC;
			best_ssr=ssr;
		end
		%disp(['model_1Vx ',num2str(x), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation),', RMSE=',num2str(RMSE)])
		ssr_matrix(x,1)=ssr;
	end
end
%-----------------P=V/C+RV'+P0+b*V'^y-----------------------
for y = pow_min:pow_max
	%fitting
	[E R b P0]=F1Sy(input_data,y);
	if min([E R b P0])>0 %Routh-Hurwitz criterion, b>0 represents a positive correlation between E and V
		%Simulation
		input=data(:,1)-P0;
		simin=[t2;input']';
		set_param('model_1Sy','StopTime','length(data)/100');
		TestOut = sim('model_1Sy','ReturnWorkspaceOutputs','on');
		%Evaluation
		out = TestOut.simout.Data(:);
		out(1)=[];
		Correlation=corr(data(:,3),out);
		diff=data(:,3)-out;
		ssr=dot(diff,diff);
		BIC=row*log(ssr)+log(row)*5;
		RMSE=sqrt(ssr/row);
		if (BIC<best_BIC)
			best_model=['model_1Sy ',num2str(y)];
			best_BIC=BIC;
			best_ssr=ssr;
		end
		%disp(['model_1Sy ',num2str(y), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation),', RMSE=',num2str(RMSE)])
		ssr_matrix(1,y)=ssr;
	end
end
%-----------------P=V/C+RV'+P0+a*V^x+b*V'^y-----------------------
for x = pow_min:pow_max
	for y = 3:2:pow_max
		%fitting
		[E R a b P0]=F1VxSy(input_data,x,y);
		if min([E R a b P0])>0 %Routh-Hurwitz criterion, a>0 represents a positive correlation between E and V, b>0 represents a positive correlation between E and V
			%Simulation
			input=data(:,1)-P0;
			simin=[t2;input']';
			set_param('model_1VxSy','StopTime','length(data)/100');
			TestOut = sim('model_1VxSy','ReturnWorkspaceOutputs','on');
			%Evaluation
			out = TestOut.simout.Data(:);
			out(1)=[];
			Correlation=corr(data(:,3),out);
			diff=data(:,3)-out;
			ssr=dot(diff,diff);
			BIC=row*log(ssr)+log(row)*7;
			RMSE=sqrt(ssr/row);
			if (BIC<best_BIC)
				best_model=['model_1VxSy ',num2str(x), ': ',num2str(y)];
				best_BIC=BIC;
				best_ssr=ssr;
			end
			%disp(['model_1VxSy ',num2str(x), ': ',num2str(y), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation),', RMSE=',num2str(RMSE)])
			ssr_matrix(x,y)=ssr;
		end
	end
end
toc
disp(['best model:',best_model, ': SSR=', num2str(best_ssr),', BIC=', num2str(best_BIC),', RMSE=',num2str(sqrt(best_ssr/row))])
%-----------------P=V/C+RV'+P0+V*a*e^(x*V)-----------------------
%{
for x = 1:10
	%fitting
	[E R a P0]=F1VexpV(input_data,x);
	if min([E R a P0])>0 %Routh-Hurwitz criterion, a>0 represents a positive correlation between E and V
		%Simulation
		input=data(:,1)-P0;
		simin=[t2;input']';
		set_param('model_1VexpV','StopTime','length(data)/100');
		TestOut = sim('model_1VexpV','ReturnWorkspaceOutputs','on');
		%Evaluation
		out = TestOut.simout.Data(:);
		out(1)=[];
		Correlation=corr(data(:,3),out);
		diff=data(:,3)-out;
		ssr=dot(diff,diff);
		BIC=row*log(ssr)+log(row)*5;
		if (BIC<best_BIC)
			best_model=['model_1VexpV ',num2str(x)];
			best_BIC=BIC;
			best_ssr=ssr;
		end
		disp(['model_1VexpV ',num2str(x), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation)])
	end
end
%-----------------P=V/C+RV'+P0+V*a*e^e^(x*V)-----------------------
for x = 1:10
	%fitting
	[E R a P0]=F1Vexp2V(input_data,x);
	if min([E R a P0])>0 %Routh-Hurwitz criterion, a>0 represents a positive correlation between E and V
		%Simulation
		input=data(:,1)-P0;
		simin=[t2;input']';
		set_param('model_1Vexp2V','StopTime','length(data)/100');
		TestOut = sim('model_1Vexp2V','ReturnWorkspaceOutputs','on');
		%Evaluation
		out = TestOut.simout.Data(:);
		out(1)=[];
		Correlation=corr(data(:,3),out);
		diff=data(:,3)-out;
		ssr=dot(diff,diff);
		BIC=row*log(ssr)+log(row)*5;
		if (BIC<best_BIC)
			best_model=['model_1Vexp2V ',num2str(x)];
			best_BIC=BIC;
			best_ssr=ssr;
		end
		disp(['model_1Vexp2V ',num2str(x), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation)])
	end
end
%}

%-----------------mix model1-----------------------
%P=EV+RV'+P0+aV'(alpha)+b*e^e^(beta*V)
%alpha=1.3;
%beta=3;
%{
for alpha = 1.1:0.1:1.9
	for beta = 1:10
		%fitting
		%[E R a P0]=F_frac1Vexp2V(input_data, alpha,beta);
		res=double(py.F_frac1Vexp2V.fit_frac1Vexp2V(input_data, alpha, beta));
		E=res(1); R=res(2); a=res(3); b=res(4);P0=res(5);
		if min([E R a b P0])>0 %Routh-Hurwitz criterion, a>0 represents a positive correlation between R and V'
			%Simulation
			input=data(:,1)-P0;
			simin=[t2;input']';
			set_param('model_frac1Vexp2V','StopTime','length(data)/100');
			TestOut = sim('model_frac1Vexp2V','ReturnWorkspaceOutputs','on');
			%Evaluation
			out = TestOut.simout.Data(:);
			out(1)=[];
			Correlation=corr(data(:,3),out);
			diff=data(:,3)-out;
			ssr=dot(diff,diff);
			BIC=row*log(ssr)+log(row)*7;
			RMSE=sqrt(ssr/row);
			disp(['model_frac1Vexp2V alpha=',num2str(alpha),', beta=',num2str(beta) ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', Correlation=', num2str(Correlation),', RMSE=',num2str(RMSE)])
			if (BIC<best_BIC)
				best_model=['model_frac1Vexp2V alpha=',num2str(alpha),', beta=',num2str(beta)];
				best_BIC=BIC;
				best_ssr=ssr;
			end
		end
	end
end
%}


%-----------------PSO-----------------

%Fractional calculus model of equation (21)
tic
[xm,fv]=PSO(@Frac1_ssr,5,1.5,2.5,0.5,5,1,1.001,1.999)
toc
ssr=-fv;
res=double(py.F_frac1.fit_frac1(input_data, xm(1)));
E=res(1); R=res(2); a=res(3); P0=res(4);
BIC=row*log(ssr)+log(row)*5;
RMSE=sqrt(ssr/row);
disp(['model_frac1 ',num2str(xm(1)), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', RMSE=',num2str(RMSE),', a=',num2str(a)])
if (BIC<best_BIC)
	best_model=['model_frac1 ',num2str(xm(1)), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', RMSE=',num2str(RMSE),', a=',num2str(a)];
	best_BIC=BIC;
	best_ssr=ssr;
end

%exponential model of equation (31)
tic
[xm,fv]=PSO(@F1Vexp2V_ssr,10,1.5,2.5,0.5,10,1,1,10)
toc
ssr=-fv;
[E R a P0]=F1Vexp2V(input_data,xm(1));
BIC=row*log(ssr)+log(row)*5;
RMSE=sqrt(ssr/row);
disp(['model_F1Vexp2V ',num2str(xm(1)), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', RMSE=',num2str(RMSE),', a=',num2str(a)])
if (BIC<best_BIC)
	best_model=['model_F1Vexp2V ',num2str(xm(1)), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', RMSE=',num2str(RMSE),', a=',num2str(a)];
	best_BIC=BIC;
	best_ssr=ssr;
end


%Mix model of equation (33)
tic
[xm,fv]=PSO(@Frac1Vexp2V_ssr,20,1.5,2.5,0.5,20,2,[0.1 1],[1.999 20])
toc
ssr=-fv;
res=double(py.F_frac1Vexp2V.fit_frac1Vexp2V(input_data, xm(1), xm(2)));
E=res(1); R=res(2); a=res(3); b=res(4);P0=res(5);
BIC=row*log(ssr)+log(row)*7;
RMSE=sqrt(ssr/row);
disp(['Mix model ',num2str(xm(1)), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', RMSE=',num2str(RMSE),', a=',num2str(a),', b=',num2str(b)]);
if (BIC<best_BIC)
	best_model=['Mix model ',num2str(xm(1)), ': SSR=', num2str(ssr),', BIC=', num2str(BIC),', RMSE=',num2str(RMSE),', a=',num2str(a),', b=',num2str(b)];
	best_BIC=BIC;
	best_ssr=ssr;
end

%-----------------fin-----------------------
disp(['best model:',best_model])

bdclose('model1')
bdclose('model2')
bdclose('model2P1')
bdclose('model_1Vx')
bdclose('model_1Sy')
bdclose('model_1VxSy')
bdclose('model_frac1')
bdclose('model_frac2')
bdclose('model_1VexpV')
bdclose('model_1Vexp2V')
bdclose('model_1Vexp2V')
bdclose('model_frac1Vexp2V')

