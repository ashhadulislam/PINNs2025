function ssr = Frac1exp2V_ssr(input_parameters)
global input_data
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
time_point=1:row;% total data points
t2=time_point/100;%sampling cycle = 10ms (0.01s)

%fitting
alpha=input_parameters(1);
beta=input_parameters(2);
res=double(py.F_frac1Vexp2V.fit_frac1Vexp2V(input_data, alpha, beta));
E=res(1); R=res(2); a=res(3); b=res(4);P0=res(5);

if min([E R a b P0])>1e-10 %Routh-Hurwitz criterion, a>0 represents a positive correlation between P and V. set 1e-10 as 0 to avoid singular point
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
	ssr=-dot(diff,diff);%Smaller SSR represents higher scores
else
%	disp('error para:')
%	disp([alpha beta E R a b P0])
	ssr=-Inf;
end

end
