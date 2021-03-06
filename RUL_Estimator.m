function [fitresult, gof] = RUL_Estimator(t, vrms)
%CREATEFIT(T,VRMS)
%  Create a fit.
%
%  Data for 'RUL_Estimator' fit:
%      X Input : t
%      Y Output: vrms
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 08-Nov-2015 03:13:03


%% Fit: 'RUL_Estimator'.
[xData, yData] = prepareCurveData( t, vrms );

% Set up fittype and options.
ft = fittype( 'exp1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.MaxIter = 500;
opts.StartPoint = [0.00104733517488278 0.000132004428834917];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Create a figure for the plots.
figure( 'Name', 'RUL_Estimator' );

% Plot fit with data.
subplot( 2, 1, 1 );
h = plot( fitresult, xData, yData );
legend( h, 'vrms vs. t', 'RUL_Estimator', 'Location', 'NorthEast' );
% Label axes
xlabel t
ylabel vrms
grid on

% Plot residuals.
subplot( 2, 1, 2 );
h = plot( fitresult, xData, yData, 'residuals' );
legend( h, 'RUL_Estimator - residuals', 'Zero Line', 'Location', 'NorthEast' );
% Label axes
xlabel t
ylabel vrms
grid on


