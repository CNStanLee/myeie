clear
clc
%% 1.2.1
% 1
% define values
fs = 8000;
d_vect = [2, 3];
note_vect = [59, 95];
start_vect = [3, 5];
music = createMusic(d_vect,note_vect,fs,start_vect); % create music
[Y,f] = my_FFT(music, fs);
plot(f, Y) % plot the dicrete Fourier transform
xlabel('frequency');
%sound(music,fs) % listen to the music
% 2
f_l = length(f);
HLP = zeros(1, f_l);
HHP = zeros(1, f_l);
HLP (find(HLP == 0) <= 24001) = 1; %all values smaller than 32000 of HLP are put to one
HHP (find(HHP == 0) > 40000) = 1;%all values larger than 32000 of HHP are put to one
% 3, 4
Y_l = Y.' .* HLP;
Y_h = Y.' .* HHP;
y_l = my_FFTinv(Y_l);
y_h = my_FFTinv(Y_h);
[Y_l,f_l] = my_FFT(y_l, fs);
[Y_h,f_h] = my_FFT(y_h, fs);
subplot(2,1,1)
plot(f_l, Y_l)% plot the figure to detect
xlabel('frequency');
subplot(2,1,2)
plot(f_h, Y_h)
xlabel('frequency');
%sound(real(y_l), fs); % detect the sound
%sound(real(y_h), fs);
%% 1.2.2
% 1
% define values
% define the first music
fs = 8000;
d_vect = [10, 10, 10, 10, 10];
note_vect = [51, 56, 61, 70, 65];
start_vect = [1, 3, 5, 7, 9];
%create a signal from 
music_21 = createMusic(d_vect,note_vect,fs,start_vect); % create music
%sound(music_21,fs)
[Y_21,f_21] = my_FFT(music_21, fs);
Y_21 = abs(Y_21);
subplot(3, 1, 1)
plot(f_21, Y_21)
xlabel('x1');
x1 = my_FFTinv(Y_21);
% 2
% define values
% define the second music
d_vect = [10, 10, 10, 10, 10];
note_vect = [73, 75, 78, 84, 89];
start_vect = [1, 3, 5, 7, 9];
music_22 = createMusic(d_vect,note_vect,fs,start_vect); % create music
%sound(music_22, fs)
[Y_22,f_22] = my_FFT(music_22, fs);
Y_22 = abs(Y_22);
subplot(3, 1, 2)
plot(f_22, Y_22)
xlabel('x2');
x2 = my_FFTinv(Y_22);
% 3
x = x1 + x2; %add two signals together
[Y_23,f_23] = my_FFT(x, fs);
Y_23 = abs(Y_23);
subplot(3, 1, 3)
plot(f_23, Y_23)
xlabel('x');
% 4
% find f = 550Hz location : 86451
% find f = -550Hz location : 65551
Y_f221 = zeros(1, length(f_23));
Y_f222 = zeros(1, length(f_23));
% restore the first part of Y_21
for i = (65551 - 23999) : (65551 + 40000)
    Y_f221(i) = Y_23(i) .* HLP(i - 65551 + 24000);
end
% restore the second part of Y_21
for i = (86451 - 39999) : (86451 + 24000)    
    Y_f222(i) = Y_23(i) .* HHP(i - 86451 + 40000);
end
Y_f22 = Y_f221 + Y_f222;
Y_f21 = Y_23.' - Y_f22;
subplot(2, 1, 1)
plot(f_23, Y_f21)
xlabel('Y_f21');
subplot(2, 1, 2)
plot(f_23, Y_f22)
xlabel('Y_f22');
% 5
% turn frequency domain into time domain
y2 = my_FFTinv(Y_f21);
y1 = my_FFTinv(Y_f22);
distance1 = y1.' - x1; % Euclidean distance of music1
distance2 = y2.' - x2; % Euclidean distance of music2
