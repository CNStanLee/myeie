% clear
clear;
close all;

% • Define variables allowing easy modification of input file (in .wav format), block size, and 
% duration (in seconds) of the input file to process.
block_size = 1024;
duration = 2;
input_filename = 'degraded.wav';

% • Process the provided "degraded.wav" file and write the output into a file named 
% "output.wav."
output_filename = 'output.wav';
% Main Process


% • Use the provided "clean.wav" (based on a real audio track) and the provided 
% "degraded.wav" (artificially degraded) for testing the algorithm and generating the 
% processed version of "degraded.wav."

% • The demo audio files should be 10 seconds long with a minimum sampling rate of 8KHz.

% • The "demo.m" should play "degraded.wav" for the first 5 seconds and then the restored 
% .wav file for the next 5 seconds.