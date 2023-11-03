function [x,new_t] = createNote(d, note, fs, start,amplitude) %the note starts after start seconds
%the arguments are the note duration, the note number, the sampling
%frequency, the start (eg if start=1, the note starts after 1 sec)
%note that with this code we prefer to choose d and start integers
%the amplitude of the sinewave is max to be 1, you can choose 0.1,0.2 .. if
%you want a lower amplitude when added to the speech file.
    f0 = 440*2^((note-69)/12);
    N = ceil(d)*fs;
    t = (1/fs)*(0:N-1)';
    x = amplitude*sin(2*pi*f0*t);
    prep = zeros(start*fs,1);
    x = [prep; x];

    new_N = ceil(start+d)*fs;
    new_t = (1/fs)*(0:new_N-1)';



    if note == -1
        x = zeros(N,1);
    end

end