clear
clc
filename = 'OSR_us_000_0010_8k.wav';
[y, Fs] = audioread(filename);

%super-imposed tone created with createNote.m
%use same sampling frequency as the speech file i.e. fs=8000Hz
note = 105; % set note
start = 1; % set start
d = 0.3; % set duration(0 - 1)
amplitude = 0.7; % set amplitude(0 - 1)
[x_noise,new_t] = createNote(d, note, Fs, start,amplitude);


%add the two signals (wav file and tone)
%x=...;
x_l = length(x_noise);
y_l = length(y);
corrupted_speech = zeros(1, y_l);
for  i = 1 : x_l
    corrupted_speech(i) = x_noise(i) + y(i);
end
for i = (x_l + 1) : y_l
    corrupted_speech(i) = y(i);
end
%listen to the resulting corrupted speech
sound(corrupted_speech);

%% wav input
%% 1.3.1
% set noise
t = 1 : 1 : y_l;
t = t.';
subplot(3, 1, 1)
plot(t, y)
subplot(3, 1, 2)
plot(new_t, x_noise)
subplot(3, 1, 3)
plot(t, corrupted_speech)
