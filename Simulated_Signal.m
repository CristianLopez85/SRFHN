clear; clc; close all;

%--------------------- Parameters -----------------------------------------
fm = 100; b = fm*3000; f0 = 2000; 
fs = 20000; N = 8000; 
t = 0:1/fs:N/fs-1/fs;
Tm2 = 1/fm; nn = Tm2*floor(t/Tm2); 
x1 = exp(-b*(t-nn).^2);x2 = sin(2*pi*f0*t);
xo = x1.*x2; xo = circshift(xo,[0,100]); noise = 0.6*randn(1,N); 
x = xo + noise; So = x(1:N);

%-------------  Plot Simulated Outer Race fault signal   ------------------
figure;
set(gcf,'position',[300 100 900 550]);set(gcf,'color','white');
subplot(321);plot(t,xo,'b');ylim([1.2*min(xo) 1.2*max(xo)]);
subplot(322);plot_fft(abs(hilbert(xo)),fs,2,0,499);
subplot(323);plot(t,So,'b');ylim([1.2*min(So) 1.2*max(So)]);
ylabel('Amplitude (V)');
subplot(324);plot_fft(abs(hilbert(So)),fs,2,0,499);
ylabel('Power (W)');

%-------------  Perform Stochastic Resonance - FHN  -----------------------

S2 = abs(hilbert(So));
Max_SNR_B=-20;
for h = 0.002:0.002:0.1
    for g = 0.01:0.01:0.3
        S3 = twosrFHN(1,1,h,g,S2);
        S3 = S3-mean(S3);
        
        fftx = fft(S3,N);
        Px = fftx.*conj(fftx)/N;
        P_S_1 = Px(round(fm*N/fs)+1);        % Signal power
        P_N_1 = sum(Px(1:N/2))-P_S_1;        % Noise power
        SNR = 10*log10(P_S_1/P_N_1);
        if SNR > Max_SNR_B
            Max_SNR_B = SNR;
            opth = h;                        % optimal h
            optg = g;                        % optimal g
        end
    end
end

%------------------  Obtain the output signal   ---------------------------
S4o=twosrFHN(1,1,opth,optg,S2);
S4o=S4o-mean(S4o);
subplot(325);plot(t,S4o,'b');
xlabel('Time (s)');
subplot(326);plot_fft(S4o,fs,2,0,499);
xlabel('Frequency (Hz)');

set(findall(gcf,'-property','FontSize'),'FontSize',14, 'FontName', 'Times New Roman')
set(gca,'XColor','k', 'YColor','k')