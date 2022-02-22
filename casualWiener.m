function [casualAudio,h] = casualWiener(orgAudio, arVoice, sigmaVoice, arNoise, sigmaNoise)

% @ NAME : Casual Wiener filter
%
% @ INPUT : orgAudio   --- Original unfilted audio
%           arVoice    --- AR coefficient for AR process AY = w
%           sigmaVoice --- PSD of white noise w
%           arNoise    --- AR coefficient for AR process AN = e
%           sigmaNoise --- PSD of white noise e
%
% @ OUTPUT: casualAudio --- Filted audio (in time domian)
%           h           --- Casual Wiener filter impulse responce
%
% @ DESCRIPTION:
% -> Phi_yy(z) = Phi_xx(z) + Phi_nn(z)
% -> Phi_yx(z) = Phi_xx(z)

% Get factorized coefficient
% -> Y = 1/A*w
% -> Phi_yy = (1/A)*sigmaw*(1/A)^-1'
% -> numYY = 1*sigmaw
% -> denYY = conv(A,Ar)
[numYY, denYY] = filtspec(1,arVoice,sigmaVoice);
[numNN, denNN] = filtspec(1,arNoise,sigmaNoise);

% -> numYX   numYY   numNN
% -> ----- = ----- - -----
% -> denYX   denYY   denNN
numYX = conv(numYY,denNN)-conv(numNN,denYY);
denYX = conv(denYY,denNN);

% -> Phi_xy(z) = Phi_yx(z^-1)' = reverse order of Phi_yx(z)
%numXY = polystar(numYX);
%denXY = polystar(denYX);

% m = 0 --- Filtering
% m > 0 --- Predicting
% m < 0 --- Smoothing
casualAudio = cw(orgAudio,numYX,denYX,numYY,denYY,0);

% Get impulse responce
delta = zeros(length(orgAudio),1);
delta(1) = 1;
h = cw(delta,numYX,denYX,numYY,denYY,0);