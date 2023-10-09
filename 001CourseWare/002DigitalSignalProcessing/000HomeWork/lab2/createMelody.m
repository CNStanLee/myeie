function MELODY = createMelody(D_VECT, NOTE_VECT, fs)
    
    NumOfDuration = length(D_VECT);
    NumOfNote = length(NOTE_VECT);
    
    % avoid the error input%
    if(NumOfDuration == 0)
        return;
    end

    if(NumOfDuration ~= NumOfNote)
        return;
    end

    % init the melody
    MELODY = [];

    % generate the melody
    for i = 1 : 1 : NumOfDuration
        MELODY = [MELODY createNote(D_VECT(i), NOTE_VECT(i), fs)];
    end

end



