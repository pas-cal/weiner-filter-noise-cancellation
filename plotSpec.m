function plotSpec(timeSeq, sampFreq)

specSeq_fft = fft(timeSeq);
specSeq_dsb = abs(specSeq_fft/length(timeSeq));
specSeq_ssb = specSeq_dsb(1:floor(length(timeSeq)/2)+1);
specSeq_ssb(2:end-1) = 2*specSeq_ssb(2:end-1);
freqUnit = sampFreq*(0:(length(timeSeq)/2))/length(timeSeq);
plot(freqUnit,specSeq_ssb)