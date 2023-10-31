clear;
close all;

Fs = 1000;  
T = 1;      
t = 0 : 1 / Fs : T - 1 / Fs;  

frequency = 5;  
amplitude = 1;  
signal = amplitude * sin(2 * pi * frequency * t);

click_amp = 10 * (rand(1, 1000) - 0.5);

pos = ceil(1000* (rand(1, 50))); 
signal(pos) = signal(pos) + click_amp(pos);

plot(t, signal);
xlabel('Time(s)');
ylabel('Amplitude');

print -depsc fig2.eps 

%%

clear;
close all;

Fs = 1000;  
T = 1;      
t = 0 : 1 / Fs : T - 1 / Fs;  

frequency = 5;  
amplitude = 1;  
signal = amplitude * sin(2 * pi * frequency * t);

[signal_c, bk] = clickGen(signal, 10, 100);

plot(t, signal_c);
xlabel('Time(s)');
ylabel('Amplitude');


