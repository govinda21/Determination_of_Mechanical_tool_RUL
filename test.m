clear all;
clc;
fprintf('The program evaluates Remaining Useful Life(RUL).\n');
d=dir('*.csv');   % return the list of csv files from the current folder
for i=1:2803
  m{i}=csvread(d(i).name);   % put into cell array
  a = m{1,i}(:,5:6);
  time = 3600 * m{1,i}(end,1) + 60 * m{1,i}(end,2) + m{1,i}(end,3);
  t(i) = time;
  F{1,1}(i,1:2) = rms(a);%imp
end
vrms1 = F{1,1}(:,1);
vrms2 = F{1,1}(:,2);
% vrms = vrms1.^2 + vrms2.^2;
[f1,b] = RUL_Estimator(t, vrms1);
%Threshold V rms chosen from observation of plot
v_thresh = [9.725 2.718 2.2]; % [vrms vrms1 vrms1 vrms2]
%function for solving inverse equation
g = @(vrms1) f1(vrms1) - v_thresh(2);
t_f(1) = fzero(g, 50000);  %start solution with initial point

fprintf('Please provide the Vrms of the tool to calculate RUL.\n');
prompt = 'What is the value  V_rms value? \n';
y = input(prompt);

g = @(vrms1) f1(vrms1) - y;
x(1) = fzero(g, 10000);

[f2,b] = RUL_Estimator(t, vrms2);
g = @(vrms2) f2(vrms2) - v_thresh(3);
t_f(2) = fzero(g, 50000);  %start solution with initial point
g = @(vrms2) f2(vrms2) - y;
x(2) = fzero(g, 10000);
if (t_f(1) - x(1)) > (t_f(2) - x(2))
    k_x = x(2);
    k_f = f2;
    k_t = t_f(2);
    k_vrms = vrms2;
    figure('Name', 'Verification using y');
else
    k_x = x(1);
    k_f = f1;
    k_t = t_f(1);
    k_vrms = vrms1;
    figure('Name', 'Verification using x');
end
% Plot it

plot(t, k_vrms, 'k-', k_x, k_f(k_x), 'r+');

a = k_t - k_x;
a = uint64(a);
hr= a/3600;
min = (a-3600*hr)/60;
sec = a - 3600*hr - 60*min;

fprintf('\n The expected RUL in the format of HH:MM:SS \n');
fprintf('%d:%d:%d \n',hr, min, sec);
