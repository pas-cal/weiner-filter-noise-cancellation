function [trainingVoice, trainingNoise, trainingLength, timeUnit] = getTrainingSeq(oxSlot, nxSlot, vxSlot, orgAudio)

% @ NAME: Get sequence for training filters
% 
% @ INPUT: oxSlot   --- The length of orginal audio sequence in micro second
%          nxSlot   --- The slot used for training (As white noise -> n)
%          vxSlot   --- The slot used for training (As white noise with human voice -> y)
%          orgAudio --- Original audio sequence
%
% @ OUTPUT: trainingVoice  --- Training voice sequence
%           trainingNoise  --- Training noise sequence
%           trainingLength --- The length of the training sequence
%           timeUnit       --- Time point of sampling

% Get training sequence as input time slot

trainingNoise = orgAudio(floor(nxSlot(1)/oxSlot*length(orgAudio)):floor(nxSlot(2)/oxSlot*length(orgAudio)));
trainingVoice = orgAudio(floor(vxSlot/oxSlot*length(orgAudio)):floor(vxSlot(2)/oxSlot*length(orgAudio)));

% Equalize the length of the training sequence

trainingLength = min(length(trainingVoice), length(trainingNoise));
trainingVoice = trainingVoice(1:trainingLength);
trainingNoise = trainingNoise(1:trainingLength);

% Get time unit for ploting purpose

timeUnit = linspace(0,oxSlot,length(orgAudio));

