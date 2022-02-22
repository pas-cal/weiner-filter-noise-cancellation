function [firAudio, ThetaFit, RYY] = firWiener(orgAudio, arVoice, sigmaVoice, arNoise, sigmaNoise)

% @ NAME: FIR Wiener Filter
%
% @ INPUT: orgAudio   --- Original audio
%          arVoice    --- A(q) for AR process A(q)Y(n) = e(n)
%          sigmaVoice --- cov{e(n)}
%          arNoise    --- A(q) for AR process A(q)N(n) = v(n)
%          sigmaNoise --- cov{v()n}
%
% @ OUTPUT: firAudio --- Filtered audio sequence
%           ThetaFit --- Theta with padding (Theta is the linear optimator in time domain)

% Get length of h(t) for FIR Wiener filter
N = length(arVoice);

% Calculate covariance
RYY = toeplitz(ar2cov(arVoice,sigmaVoice,N)+ar2cov(arNoise,sigmaNoise,N));
RYx = ar2cov(arVoice,sigmaVoice,N);

% Equalize the size
RYx = RYx(1:N);
RYY = RYY(1:N,1:N);

% Calculate linear optimator Theta
ThetaFit = zeros(floor(length(orgAudio/2))+1,1);
Theta = inv(RYY)*RYx;
ThetaFit(1:length(Theta),1) = Theta; 
firAudio = conv(Theta,orgAudio);

