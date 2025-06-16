function ssr = F2P1(input_parameters)
global input_data
global data
global alpha
global E
global R
global I
global a
global P0
global simin

data=load(input_data);%P V' V
[row,column]=size(data);
t=1:row;% total data points
t2=t/100;%sampling cycle = 10ms (0.01s)

%fitting
E=input_parameters(1); R=input_parameters(2); I=input_parameters(3);a=input_parameters(4); P0=input_parameters(5);
	if min([E R I a P0])>1e-10 %Routh-Hurwitz criterion, a>0 represents a positive correlation between P and V'. set 1e-10 as 0 to avoid singular point
		%Simulation
		input=data(:,1)-P0;
		simin=[t2;input']';
		set_param('model2P1','StopTime','length(data)/100');
		TestOut = sim('model2P1','ReturnWorkspaceOutputs','on');
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
