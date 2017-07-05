clear Sys Exp Vary Opt Pulse sigmas 
Sys = [];
% Exp = [];
Vary = [];
Opt = [];

Pulse.Type = 'quartersin/linear';
Pulse.trise = 0.015; % us
Pulse.ComplexExcitation = 0;

PC = [0 1; pi -1];
% PC = 0;
Exp.t = [0.1 0.2 0.1 0.2];
Exp.Pulses = {Pulse 0 Pulse 0};


Opt.Detection = [1 1 1 1];
Opt.Relaxation = [0 0 0 0];
Opt.StateTrajectories = [];
Opt.Detect = [];
Opt.ExcitationOperator = [];

Exp.Frequency = [-100 100] +1500;
Exp.Flip = [pi pi];
Exp.PhaseCycle{1} = PC;

Exp.TimeStep = 0.0001; % us

Exp.Inc1 = {'p1.Frequency' [0 100];
            'p2.Frequency' [-100 0]};
Exp.Inc2 = {'d1' 0.2};
Exp.nPoints = [5];


[t, signal, state, sigmas, Eventsnew]=spidyan(Sys,Exp,Opt);


% disp(state)

try
a = squeeze(signal(1,:,:));
b = squeeze(signal(2,:,:));
c = squeeze(signal(3,:,:));
d = squeeze(signal(4,:,:));
figure(2); clf
plot(t(1,:),real(a))
hold on
plot(t(2,:),real(b))
plot(t(3,:),real(c))
plot(t(4,:),real(d))

catch
  figure(3);clf
  hold on
  for i = 1: length(signal)
    plot(t{i},real(signal{i}))
    
  end
end

% 
% Events{1}.Detection = 0;
% Events{3}.Detection = 0;
% Events{2}.Detection = 0;
% Events{4}.Detection = 0;
%         
% tic
% [t, signal,state,sigma,Eventnew]=evolve2(Sigma,Ham, Det, Events, Relaxation);
% toc
% % profile on
% tic
% [t, signal,state,sigmas]=evolve2(Sigma,Ham, Det, Eventsnew, Relaxation, Vary);
% % profile off
% toc
% % profile report
% disp(state)
% % figure(2); clf
% % plot(t,real(signal))
% % 
% Events{1}.Detection = 0;
% Events{3}.Detection = 0;
% Events{2}.Detection = 0;
% Events{4}.Detection = 0;
%         
% tic
% [t, signal,state,sigma,Eventsnew]=evolve2(Sigma,Ham, Det, Events, Relaxation,Vary);
% toc
% disp(state)
% 
% tic
% [t, signal,state,sigma,Eventsnew]=evolve2(Sigma,Ham, Det, Eventsnew, Relaxation,Vary);
% toc
% disp(state)