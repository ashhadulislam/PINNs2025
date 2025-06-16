%Main pipeline that is consistent with the results presented in the paper.
%Using global variables is beneficial for Simulink computation.
global input_data	% for parameter estimation
global data		% for Simulink computation (eg. Initial value of integration module in Simulink).
global simin		% time series based on data, input of Simulink models
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

%Comparing parameter estimation and model simulation results of different models
input_data='data/case1PCAC1.txt';
data=load(input_data);%P V' V
tic
FS_all();%FS_all: perform parameter estimation and model simulation on all types of models
toc

%different ventilation modes
input_data='data/case1VCAC1.txt';
data=load(input_data);%P V' V
FS_all();

input_data='data/case1VCSIMV1.txt';
data=load(input_data);%P V' V
FS_all();

%The data from the first time period is used for parameter estimation, while the data from the second time period is used for simulation testing.
input_data='data/case1PCAC1.txt';%for Simulink computation
data=load(input_data);%for Simulink computation
input_data='data/case1PCAC2.txt';% for model fitting
FS_all();

%calculation based on different individual data
input_data='data/case2VCAC1.txt';
data=load(input_data);%P V' V
FS_all();

close all;
clear all;
