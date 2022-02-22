function [noncasualAudio,h] = noncasualWiener(orgAudio, arVoice, sigmaVoice, arNoise, sigmaNoise)

% @ NAME : Non-casual Wiener filter
%
% @ INPUT : orgAudio   --- Original unfilted audio
%           arVoice    --- AR coefficient for AR process AY = w
%           sigmaVoice --- PSD of white noise w
%           arNoise    --- AR coefficient for AR process AN = e
%           sigmaNoise --- PSD of white noise e
%
% @ OUTPUT: noncasualAudio --- Filted audio (in time domian)
%           h              --- Non-casual Wiener filter impulse responce
%
% @ DESCRIPTION:
% -> Phi_yy(z) = Phi_xx(z) + Phi_nn(z)
% -> Phi_yx(z) = Phi_xx(z)

%% With AR estimation

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

% ->     Phi_xy   numNC   numXY*denYY
% -> H = ------ = ----- = -----------
% ->     Phi_yy   denNC   denXY*numYY
numNC = conv(numYX,denYY);
denNC = conv(denYX,numYY);

% Filtering
noncasualAudio = ncfilt(numNC,denNC,orgAudio);

% Get impulse responce
delta = zeros(length(orgAudio),1);
delta(1) = 1;
h = ncfilt(numNC,denNC,delta);

