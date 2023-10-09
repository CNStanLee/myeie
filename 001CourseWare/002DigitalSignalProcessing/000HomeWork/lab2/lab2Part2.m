%clear
clear;
close all;

%parameter define
fs = 8000;
d = 2;

%1.3.3
[y, t] = createNote(d, 53, fs);
%sound(y, fs);
figure(Name = 'Figure 3 Note Wave(53)');

plot(t, y);

xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.1]);
ylim([-2, 2]);
title('Figure 3 Note Wave(53)');
grid on;

%1.3.4
[y, t] = createNote(d, -1, fs);
%sound(y, fs);
figure(Name = 'Figure 4 Note Wave(-1)');

plot(t, y);

xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, 0.1]);
ylim([-2, 2]);
title('Figure 4 Note Wave(-1)');
grid on;