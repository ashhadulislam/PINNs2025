global input_data	% for model fitting
global data	% for Simulink computation (eg. Initial value of integration module in Simulink).
global simin	% time series based on data, input of Simulink models
global TestOut	% Output of Simulink

%These global variable names are consistent with the formulas in the paper.
global alpha
global beta
global E
global R
global I
global a
global b
global P0
global x
global y

%Comparing fitting and simulation results of different models
input_data='data/case1PCAC1.txt';
data=load(input_data);%P V' V
