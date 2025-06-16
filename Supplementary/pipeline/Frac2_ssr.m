function ssr = Frac1_ssr(input_parameters)
global input_data
global data
global alpha
global beta
global E
global R
global a
global b
global P0
global simin

data=load(input_data);%P V' V
[row,column]=size(data);
t=1:row;% total data points
t2=t/100;%sampling cycle = 10ms (0.01s)

%fitting
alpha=input_parameters(1);
beta=input_parameters(2);
%res=double(py.F_frac2.fit_frac2(input_data, input_parameters(1), input_parameters(2)));
%E=res(1); R=res(2); a=res(3);b=res(4); P0=res(5);
[E R a b P0]=F_frac2(input_data, alpha,beta);
if min([E R a b P0])>1e-10 %Routh-Hurwitz criterion, a>0 represents a positive correlation between P and V'. set 1e-10 as 0 to avoid singular point
	%Simulation
	input=data(:,1)-P0;
	simin=[t2;input']';
	set_param('model_frac2','StopTime','length(data)/100');
	TestOut = sim('model_frac2','ReturnWorkspaceOutputs','on');
	%Evaluation
	out = TestOut.simout.Data(:);
	out(1)=[];
	Correlation=corr(data(:,3),out);
	diff=data(:,3)-out;
	ssr=-dot(diff,diff);%Smaller SSR represents higher scores
else
	ssr=-Inf;
end

end
