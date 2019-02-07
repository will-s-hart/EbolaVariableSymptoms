clear all; close all; clc;

%% This code accompanies the manuscript entitled "Accurate forecasts of
%% interventions against Ebola may require models that account for
%% variations in symptoms during infection" by Hart et al. For further
%% information about the paper or this code, please email
%% robin.thompson@chch.ox.ac.uk

%% We request that users cite the original publication when referring to
%% this code or any results generated from it.


% This code reproduces the panels in Figure 3 of our paper.


% Load data and parameters for either the DRC epidemic (in the file
% beniparams.m) or for the Liberia epidemic (in the file liberiaparams.m).

beniparams %change to 'liberiaparams' for the Liberia outbreak


% Simulate the constant and variable symptoms models under initial
% surveillance, and compute cumulative number of observed cases; we have:
% y(1) = S, y(2) = E, y(3) = I_1, y(4) = I_2, y(5) = I_3, y(6) = R,
% y(7) = C.

options = odeset('RelTol',1e-10,'AbsTol',1e-10);

[~,y_cs] = ode45(@(t,y)SEI3RC_RHS(t,y,params_cs),t_cs,y0,options);
[~,y_vs] = ode45(@(t,y)SEI3RC_RHS(t,y,params_vs),t_vs,y0,options);

cases_cs = y_cs(:,6) + y_cs(:,7);
cases_vs = y_vs(:,6) + y_vs(:,7);


% Simulate the constant and variable symptoms models under increased
% surveillance, and compute the cumulative number of observed cases.

[~,y_new_cs] = ode45(@(t,y)SEI3RC_RHS(t,y,params_new_cs),t_cs,y0,options);
[~,y_new_vs] = ode45(@(t,y)SEI3RC_RHS(t,y,params_new_vs),t_vs,y0,options);

cases_new_cs = y_new_cs(:,6) + y_new_cs(:,7);
cases_new_vs = y_new_vs(:,6) + y_new_vs(:,7);


% Plot a bar chart of the case data from the epidemic

figure(1); hold on;
set(gcf,'Position',[360 278 560 560])
ax1 = gca;
ax1.FontSize = 20;
ax1.TitleFontSizeMultiplier = 1;
ax1.LabelFontSizeMultiplier = 1;
ax1.FontWeight = 'bold';
ax1.LineWidth = 1.5;

t_midpts = [3.5;t_data(1:(end-1))+0.5*diff(t_data)];
bar_widths = [7;diff(t_data)];
t_data_plus_start = [0;t_data];
for i=1:length(t_data)
    rectangle('position',[t_data_plus_start(i),0,bar_widths(i),case_data(i)],'FaceColor',[0,0.4470,0.7410])
end

xlim(t_range)
xticks(axis_times)
xticklabels(string(axis_dates,'dd-MMM yy'))
xlabel('Week end date')
ylabel('Number of cases')
set(ax1,'Layer', 'Top')
axis square


% Plot the model fit against the cumulative incidence data, for both the
% constant infectiousness and variable infectiousness models.

figure(); hold on;
set(gcf,'Position',[360 278 560 560])
ax1 = gca;
ax1.FontSize = 20;
ax1.TitleFontSizeMultiplier = 1;
ax1.LabelFontSizeMultiplier = 1;
ax1.FontWeight = 'bold';
ax1.LineWidth = 1.5;

plot(t_cs,cases_cs,'b:','linewidth',2);
plot(t_vs,cases_vs,'g--','linewidth',2);
plot(t_data,cumulative_case_data,'r.','markersize',15);

xlim(t_range)
xticks(axis_times)
xticklabels(string(axis_dates,'dd-MMM yy'))
xlabel('Week end date')
ylabel('Cumulative number of cases')
axis square
legend('Constant symptoms model','Variable symptoms model')


% Plot the number of observed cases when the frequency of surveillance is
% increased, for both the constant symptoms and variable symptoms models.

figure(); hold on;
set(gcf,'Position',[360 278 560 560])
ax1 = gca;
ax1.FontSize = 20;
ax1.TitleFontSizeMultiplier = 1;
ax1.LabelFontSizeMultiplier = 1;
ax1.FontWeight = 'bold';
ax1.LineWidth = 1.5;

plot(t_cs,cases_new_cs,'b','linewidth',2);
plot(t_vs,cases_new_vs,'g','linewidth',2);

xlim(t_range)
xticks(axis_times)
xticklabels(string(axis_dates,'dd-MMM yy'))
xlabel('Week end date')
ylabel('Cumulative number of cases')
axis square
legend('Constant symptoms model','Variable symptoms model')


%%


% The following function produces the right hand side of the system of
% differential equations in the SEI_{1}I_{2}I_{3} model.

function y_dot = SEI3RC_RHS(t,y,params)
% y(1) = S, y(2) = E, y(3) = I_1, y(4) = I_2, y(5) = I_3, y(6) = R,
% y(7) = C

beta0 = params(1);
beta1 = params(2);
T = params(3);
gamma = params(4);
mu = params(5);
delta1 = params(6);
delta2 = params(7);
delta3 = params(8);

if t < T
    beta = beta0;
else
    beta = beta1;
end

y_dot(1) = -beta*y(1)*(y(3)+y(4)+y(5));
y_dot(2) = beta*y(1)*(y(3)+y(4)+y(5))-gamma*y(2);
y_dot(3) = gamma*y(2) - (mu + delta1)*y(3);
y_dot(4) = mu*y(3) - (mu + delta2)*y(4);
y_dot(5) = mu*y(4) - (mu + delta3)*y(5);
y_dot(6) = mu*y(5);
y_dot(7) = delta1*y(3) + delta2*y(4) + delta3*y(5);

y_dot = y_dot';
end