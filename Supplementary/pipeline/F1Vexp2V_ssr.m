function ssr = F1Vexp2V_ssr(input_parameters)
global input_data
global x
global E
global R
global a
global P0
global simin

data=load(input_data);%P V' V
[row,column]=size(data);
time_point=1:row;% total data points
t2=time_point/100;%sampling cycle = 10ms (0.01s)

%fitting
%disp(['x=',num2str(input_parameters(1)),',time length=',num2str(length(data)/100)])
x=input_parameters(1);
[E R a P0]=F1Vexp2V(input_data,input_parameters(1));

if min([E R a P0])>1e-10 %Routh-Hurwitz criterion, a>0 represents a positive correlation between P and V. set 1e-10 as 0 to avoid singular point
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
	ssr=-dot(diff,diff);%Smaller SSR represents higher scores
else
	ssr=-Inf;
end

end
