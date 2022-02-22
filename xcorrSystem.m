function [ryy, rxx, rnn, rxy] = xcorrSystem(trainingVoice, trainingNoise)

% Double side covariance
ryy_ds = xcorr(trainingVoice);
rnn_ds = xcorr(trainingNoise);

% Single side covariance
ryy = ryy_ds(floor(length(ryy_ds)/2)+1:end);
rnn = rnn_ds(floor(length(ryy_ds)/2)+1:end);

% Assume x is uncorrelated to n for y = x + n
% ryx(k) = rxx(k) = ryy(k) - rnn(k)
rxx = ryy - rnn;
% rxy(k) = ryx(-k)'
rxy = ryy_ds(1:floor(length(ryy_ds)/2)+1) - rnn_ds(1:floor(length(ryy_ds)/2)+1);
