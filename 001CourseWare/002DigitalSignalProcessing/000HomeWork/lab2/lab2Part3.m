
% 1.4.3
note_durations = [0.25, 0.125, 0.125, 0.25, 0.125];
note_pitch = [64, 64, 62, 64, 57];
fs = 8000;


melody = createMelody(note_durations, note_pitch, fs);
d = sum(note_durations); % calculate the total time
t = 0 : 1/fs : (d - 1 / fs);

%sound(melody, fs);

% save the melody
filename = 'Melody1.wav';
audiowrite(filename, melody, fs);

figure;
plot(t, melody);
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, d]);
ylim([-2, 2]);
title('Figure 5 Melody Waveform');
grid on;

% 1.4.4
note_pitch2 = note_pitch + 12;
note_durations2 = note_durations ./ 1.5;

melody2 = createMelody(note_durations2, note_pitch2, fs);
%d = sum(note_durations2); % calculate the total time
%t = 0 : 1/fs : (d - 1 / fs);

sound(melody2, fs);

% save the melody
filename = 'Melody1_Fast_highPatch.wav';
audiowrite(filename, melody2, fs);

%%
%1.4.5
%Create Music Test

fs = 8000;

note_durations = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
note_pitch = [60, 60, 67, 67, 69, 69, 67];
start_time = [1, 2, 3, 4, 5, 6, 7];

music = createMusic(note_durations, note_pitch, start_time, fs);

d = length(music) / fs;
t = 0 : 1/fs : (d - 1 / fs);

filename = 'Music.wav';
audiowrite(filename, music, fs);

figure;
plot(t, music);
xlabel('time t(s)');
ylabel('Amplitude');
xlim([0, d]);
ylim([-2, 2]);
title('Figure 6 Music Waveform');
grid on;

sound(music, fs);




