function [x, t] = createNote(d, note, fs)
%Create a note, d(duration), note(NO of the note), fs(sampling frequency)
    fnote = 440 * 2^((note - 69) / 12);
    t = 0 : (1/fs) : (d -(1/fs));
    if(note == -1)
        x = zeros(size(t));
    else
        x = sin(2 * pi * fnote * t);
    end

end