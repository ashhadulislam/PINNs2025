function ssr = F1Vexp2V_SexpS_ssr_all(input_parameters)
global input_data
global x
global y
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
%disp(['x=',num2str(input_parameters(1)),',time length=',num2str(length(data)/100)])
disp(['E=',num2str(input_parameters(1)),' R=',num2str(input_parameters(2)),' a=',num2str(input_parameters(3)),' x=',num2str(input_parameters(4)),' b=',num2str(input_parameters(5)),' y=',num2str(input_parameters(6)),' P0=',num2str(input_parameters(7))])
E=input_parameters(1);
R=input_parameters(2);
a=input_parameters(3);
x=input_parameters(4);
b=input_parameters(5);
y=input_parameters(6);
P0=input_parameters(7);

if min([E R a b P0])>1e-10 %Routh-Hurwitz criterion, a>0 represents a positive correlation between P and V. set 1e-10 as 0 to avoid singular point
	%Simulation
	input=data(:,1)-P0;
	simin=[t2;input']';
	set_param('model_1Vexp2V_SexpS','StopTime','length(data)/100');
	TestOut = sim('model_1Vexp2V_SexpS','ReturnWorkspaceOutputs','on');
	%Evaluation
	out = TestOut.simout.Data(:);
	out(1)=[];
	Correlation=corr(data(:,3),out);
	diff=data(:,3)-out;
	ssr=-dot(diff,diff);%Smaller SSR represents higher scores
else
%	disp('error para:')
%	disp([x E R a P0])
	ssr=-Inf;
end

end
