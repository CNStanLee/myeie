clear all
filename = 'OSR_us_000_0010_8k.wav';
[y, fs] = audioread(filename);

%super-imposed tone created with createNote.m
%use same sampling frequency as the speech file i.e. fs=8000Hz
[x,new_t] = createNote(d,note,fs,start,amplitude);


%add the two signals (wav file and tone)
%x=...;
corrupted_speech = x+y;

%listen to the resulting corrupted speech
sound(corrupted_speech);