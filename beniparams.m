% This code contains the parameters for the models fitted to the ongoing
% Ebola epidemic in the DRC. It also imports the epidemic data, contained
% in the file 'benidata.csv', into MATLAB.


% Assumed parameters in fitted model

N = 230000;
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


% Import data from the file 'benidata.csv' (we assume the start of the
% first reporting week is time 0).

data_table = readtable('benidata.csv','Format','%{dd/MM/yy}D %f');
case_data = data_table.Cases(:);
cumulative_case_data = cumsum(case_data);
beni_dates = data_table.Date(:);

t_data = datenum(beni_dates)-datenum(beni_dates(1))+7;
no_weeks = ceil((t_data(end)-t_data(1))/7)+1;
start_date = beni_dates(1) - caldays(7);


% Fitted parameters for constant and variable symptoms models

beta0_cs = 8.4258e-7;
beta1_cs = 3.6761e-7;
T_cs = 90;
t_start_cs = -32;

beta0_vs = 8.0995e-7;
beta1_vs = 3.5863e-7;
T_vs = 89;
t_start_vs = -32;


% Initial conditions; we have:
% y(1) = S, y(2) = E, y(3) = I_1, y(4) = I_2, y(5) = I_3, y(6) = R,
% y(7) = C.

y0 = [N-1,1,0,0,0,0,0]';


% Vectors of times at which model solutions are to be computed

t_cs = (t_start_cs:0.1:(2*7*no_weeks))';
t_vs = (t_start_vs:0.1:(2*7*no_weeks))';


% Times and corresponding dates for figure axes

axis_times = 7*((-1):10:(2*no_weeks))'+2;
axis_dates = start_date + caldays(7*((-1):10:(2*no_weeks)))' + caldays(2);
t_range = [-9,max(axis_times)];


% Vector of parameters for constant and variable symptoms models under
% original and increased surveillance

params_cs = [beta0_cs,beta1_cs,T_cs,gamma,mu,delta,delta,delta];
params_vs = [beta0_vs,beta1_vs,T_vs,gamma,mu,delta1,delta2,delta3];

params_new_cs = [beta0_cs,beta1_cs,T_cs,gamma,mu,delta_new,delta_new,delta_new];
params_new_vs = [beta0_vs,beta1_vs,T_vs,gamma,mu,delta1_new,delta2_new,delta3_new];