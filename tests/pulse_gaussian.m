function [err,data] = test(opt,olddata)

% Compare pulse() output pulse shapes with mathematical expressions
%--------------------------------------------------------------------------

% Gaussian pulse with frequency offset
Params.tp = 0.200; % us
Params.Type = 'gaussian';
Params.tFWHM = 0.064; % us
Params.Amplitude = (pi/Params.tFWHM)/(2*pi);
Params.CenterFreq = 100; % MHz
Params.TimeStep = 0.0001;

t0 = 0:0.0001:Params.tp;
A = gaussian(t0,Params.tp/2,Params.tFWHM);
A = Params.Amplitude*(A/max(A));
f = cos(2*pi*Params.CenterFreq*t0)+1i*sin(2*pi*Params.CenterFreq*t0);
y0 = A.*f;

[t,y] = pulse(Params);

y0 = interp1(t0,y0,t,'spline');

err(1) = ~areequal(y0,y,1e-12);

% Gaussian pulse with truncation
clearvars -except err
dt = 0.001; % us
t0 = -0.300:dt:0.300; % us
A = gaussian(t0,0,0.100);
A = A/max(A);
ind = find(round(abs(A-0.5)*1e5)/1e5==0);
t0 = t0(ind(1):ind(2))-t0(ind(1));
y0 = A(ind(1):ind(2));

Params.tp = t0(end); % us
Params.Type = 'gaussian';
Params.trunc = 0.5;
Params.TimeStep = dt;
Params.Amplitude = 1;

[~,y] = pulse(Params);

err(2) = ~areequal(y0,y,1e-12);

err = any(err);

data = [];