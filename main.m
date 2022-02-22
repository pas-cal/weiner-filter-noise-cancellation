%% Initial
clf; clc; clear all;
% orgSound      S: 00'00"000 E: 00'01"987
% trainingNoise S: 00'01"700 E: 00'01"900
% trainingVoice S: 00'00"300 E: 00'00"500
addpath("./mfiles")
[orgAudio, sampOrgFreq] = audioread("EQ2401project1data2022.wav");
[trainingNoise, sampNoiseFreq] = audioread("trainingNoise.wav");
[trainingVoice, sampVoiceFreq] = audioread("trainingVoice.wav");
trainingLength = length(trainingVoice);
Ryy = 0;
Ryylp = 0;
N = 200;
Fp= 1750;
RipP  = 0.00057565; %P2P Ripple, 10^-2 dB
RipST = 1e-4; %80 dB stopband attenuation
fcov = firceqrip(N,Fp/(sampOrgFreq/2),[RipP RipST],'passedge');

lowpassFIR = dsp.FIRFilter('Numerator', fcov);
trainingVoiceFIR = lowpassFIR(trainingVoice);

[arVoice, sigmaVoice] = getARParameter(trainingVoice, floor(trainingLength/200));
[arVoiceLP, sigmaVoiceLP] = getARParameter(trainingVoiceFIR, floor(trainingLength/200));
[arNoise, sigmaNoise] = getARParameter(trainingNoise, floor(trainingLength/200));

%% Main

[firAudio, firh] = firWiener(orgAudio,arVoice,sigmaVoice,arNoise,sigmaNoise);
[firLPAudio, firlph] = firWiener(orgAudio,arVoiceLP,sigmaVoiceLP,arNoise,sigmaNoise);
[ncAudio, nch] = noncasualWiener(orgAudio,arVoice,sigmaVoice,arNoise,sigmaNoise);
[cAudio, ch] = casualWiener(orgAudio,arVoice,sigmaVoice,arNoise,sigmaNoise);


%% Spectrum Analysis

% Get spectrum of filters
[firH,firHFreqUnit,Ryy] = getSpectrum(firh,sampOrgFreq);
[firLPH,firLPHFreqUnit,Ryylp] = getSpectrum(firlph,sampOrgFreq);
[ncH,ncHFreqUnit] = getSpectrum(nch,sampOrgFreq);
[cH,cHFreqUnit] = getSpectrum(ch,sampOrgFreq);

% Get spectrum of audio sequences
[orgAudioSpec,orgASFreqUnit] = getSpectrum(orgAudio,sampOrgFreq);
[firAudioSpec,firASFreqUnit] = getSpectrum(firAudio,sampOrgFreq);
[firlpAudioSpec, firlpASFreqUnit] = getSpectrum(firLPAudio, sampOrgFreq);
[ncAudioSpec,ncASFreqUnit] = getSpectrum(ncAudio,sampOrgFreq);
[cAudioSpec,cASFreqUnit] = getSpectrum(cAudio,sampOrgFreq);

%% Plot

figure(1)
plotSpec(trainingVoice,sampVoiceFreq);
hold on;
plotSpec(trainingVoiceFIR,sampNoiseFreq);
plotSpec(trainingNoise,sampNoiseFreq);

xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("Spectrum of training sequences");
legend("Voice <Y(n)>", "Filtered Voice <Y(n))>" ,"Noise <N(n)>");
hold off

figure(2)
hold on
subplot(2,2,1)
plotter(0,orgAudio,sampOrgFreq,'freq')
subplot(2,2,2)
plotter(0,orgAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.9 1 0.1],'String', 'Noisy Input Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

subplot(2,2,3)
plotter(0,firAudio,sampOrgFreq,'freq')
subplot(2,2,4)
plotter(0,firAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.425 1 0.1],'String', 'FIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

figure(3)
subplot(2,2,1)
plotter(0,ncAudio,sampOrgFreq,'freq')
subplot(2,2,2)
plotter(0,ncAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.9 1 0.1],'String', 'Non-Causal IIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

subplot(2,2,3)
plotter(0,cAudio,sampOrgFreq,'freq')
subplot(2,2,4)
plotter(0,cAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.425 1 0.1],'String', 'Causal IIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')
hold off

figure(4) %All 5 figures on one plot
hold on
subplot(5,2,1)
plotter(0,orgAudio,sampOrgFreq,'freq')
subplot(5,2,2)
plotter(0,orgAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.87 1 0.1],'String', 'Noisy Input Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

subplot(5,2,3)
plotter(0,firAudio,sampOrgFreq,'freq')
subplot(5,2,4)
plotter(0,firAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.7 1 0.1],'String', 'FIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

subplot(5,2,5)
plotter(0,ncAudio,sampOrgFreq,'freq')
subplot(5,2,6)
plotter(0,ncAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.52 1 0.1],'String', 'Non-Causal IIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

subplot(5,2,7)
plotter(0,cAudio,sampOrgFreq,'freq')
subplot(5,2,8)
plotter(0,cAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.35 1 0.1],'String', 'Causal IIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')

subplot(5,2,9)
plotter(0,firLPAudio,sampOrgFreq,'freq')
subplot(5,2,10)
plotter(0,firLPAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.17 1 0.1],'String', 'FIR Filtered Audio with a low pass filter', 'EdgeColor', 'none','HorizontalAlignment', 'center')

hold off

figure(5)
hold on;
grid on;
plot(firHFreqUnit, firH);
plot(firLPHFreqUnit, firLPH);
plot(ncHFreqUnit, ncH);
plot(cHFreqUnit, cH);
xlabel("Frequency (Hz)");
ylabel("Magnitude");
%xlim([0 4000])
%ylim([0 1.5e-4])
title("Filter Spectra");
legend("FIR Wiener Filter", "FIR Wiener Filter with Low Pass", "Non-casual Wiener Filter", "Casual Wiener Filter");
hold off;

figure(6)
plot(orgASFreqUnit,orgAudioSpec);
hold on
plot(firASFreqUnit, firAudioSpec);
plot(firlpASFreqUnit,firlpAudioSpec);
plot(ncASFreqUnit, ncAudioSpec);
plot(cASFreqUnit, cAudioSpec);
%xlim([0 4000])
%ylim([0 0.08])
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("Audio Spectra");
legend("Origninal Audio", "FIR Wiener Audio", "FIR Wiener Audio with Low Pass", "NC-Wiener Audio", "C-Wiener Audio");

figure(7)
hold on
subplot(2,2,1)
plotter(0,firAudio,sampOrgFreq,'freq')
subplot(2,2,2)
plotter(0,firAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.9 1 0.1],'String', 'FIR Filtered Audio', 'EdgeColor', 'none','HorizontalAlignment', 'center')
hold off

subplot(2,2,3)
plotter(0,firLPAudio,sampOrgFreq,'freq')
subplot(2,2,4)
hold on
plotter(0,firLPAudio,sampOrgFreq,'time')
annotation('textbox', [0 0.425 1 0.1],'String', 'FIR Filtered Audio with a low pass filter', 'EdgeColor', 'none','HorizontalAlignment', 'center')
hold off
