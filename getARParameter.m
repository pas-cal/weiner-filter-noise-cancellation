function [A, Sigma] = getARParameter(audioSeq, order)

% @ NAME: Get AR Parameter
%
% @ INPUT: audioSeq --- Audio sequences
%          order    --- Order of estimated AR model
%
% @ OUTPUT: A       --- AR parameter A(q) <A(q)Y(n) = e(n)>
%           Sigma   --- Variance of white noise e(n)

% Using least-squares estimate the parameters of an AR model
estAR = ar(audioSeq,order);

% Get A(q)
A = estAR.A;

% Get Sigma
Sigma = estAR.NoiseVariance;