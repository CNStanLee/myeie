clear
clc
%% 1.1.1
% 1
% define values
fs = 8000;
note = 110;
d = 2;
start = 0;
% 2
[x, new_t] = createNote(d, note, fs, start); % create a new note
[Y,f] = my_FFT(x, fs); % Fourier transform
Y = abs(Y);
t(1) = 0;
for i = 2 : (length(f))
    t(i) = t(i - 1) + 1/f(i); % set the time 
end
plot(f, Y) % plot the dicrete Fourier transform
xlabel('frequency');
% 3
note_new = 110; %create a new note
[x_new, t_new] = createNote(d, note_new, fs, start); % create a new note
[Y_new,f_new] = my_FFT(x_new, fs); % Fourier transform
Y_new = abs(Y_new);
%% 1.1.2
% 1
% set parameters
d_vect = [2 3 1 2];
note_vect = [59, 42, 53, 95];
start_vect = [3, 5, 9, 11];
music = createMusic(d_vect,note_vect,fs,start_vect);
% 2
[Y_music,f_music] = my_FFT(music, fs); %create a music
plot(f_music, Y_music)

%% 1.1.2

f0 = 440*2^((110-69)/12);

