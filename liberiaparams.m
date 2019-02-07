% This code contains the parameters for the models fitted to the 2014-16
% Ebola epidemic in the Liberia. It also imports the epidemic data,
% contained in the file 'liberiadata.csv', into MATLAB.


% Assumed parameters in fitted model

N = 4500000;
gamma = 1/7;
mu = 3/(9.8);
Delta = 21;
p = 0.6; %for const symptoms model
p1 = 0.1; %for var symptoms model
p2 = 0.8; %for var symptoms model
p3 = 0.9; %for var symptoms model

delta = 1/(Delta*((1/p)-(1/2))); %for const symptoms model
delta1 = 1/(Delta*((1/p1)-(1/2))); %for var symptoms model
delta2 = 1/(Delta*((1/p2)-(1/2))); %for var symptoms model
delta3 = 1/(Delta*((1/p3)-(1/2))); %for var symptoms model


% Parameters changed under increased surveillance

Delta_new = 14;

delta_new = 1/(Delta_new*((1/p)-(1/2))); %for const symptoms model
delta1_new = 1/(Delta_new*((1/p1)-(1/2))); %for var symptoms model
delta2_new = 1/(Delta_new*((1/p2)-(1/2))); %for var symptoms model
delta3_new = 1/(Delta_new*((1/p3)-(1/2))); %for var symptoms model


% Import data from the file 'liberiadata.csv' (we assume the start of the
% first reporting week is time 0).

data_table = readtable('liberiadata.csv','Format','%{dd/MM/yy}D %f');
case_data = data_table.Cases(:);
cumulative_case_data = cumsum(case_data);
liberia_dates = data_table.Date(:);

t_data = datenum(liberia_dates)-datenum(liberia_dates(1))+7;
no_weeks = ceil((t_data(end)-t_data(1))/7)+1;
start_date = liberia_dates(1) - caldays(7);


% Fitted parameters for constant and variable symptoms models

beta0_cs = 4.5368e-8;
beta1_cs = 1.8886e-8;
T_cs = 189;
t_start_cs = 5;

beta0_vs = 4.3316e-8;
beta1_vs = 1.8077e-8;
T_vs = 189;
t_start_vs = 3;


% Initial conditions; we have:
% y(1) = S, y(2) = E, y(3) = I_1, y(4) = I_2, y(5) = I_3, y(6) = R,
% y(7) = C.

y0 = [N-1,1,0,0,0,0,0]';


% Vectors of times at which model solutions are to be computed

t_cs = (t_start_cs:0.1:(7*(no_weeks+12)))';
t_vs = (t_start_vs:0.1:(7*(no_weeks+12)))';


% Times and corresponding dates for figure axes

axis_times = 7*((-1):28:(no_weeks+12))';
axis_dates = start_date + caldays(7*((-1):28:(no_weeks+12)))';
t_range = [-14,max(axis_times)];


% Vector of parameters for constant and variable symptoms models under
% original and increased surveillance

params_cs = [beta0_cs,beta1_cs,T_cs,gamma,mu,delta,delta,delta];
params_vs = [beta0_vs,beta1_vs,T_vs,gamma,mu,delta1,delta2,delta3];

params_new_cs = [beta0_cs,beta1_cs,T_cs,gamma,mu,delta_new,delta_new,delta_new];
params_new_vs = [beta0_vs,beta1_vs,T_vs,gamma,mu,delta1_new,delta2_new,delta3_new];