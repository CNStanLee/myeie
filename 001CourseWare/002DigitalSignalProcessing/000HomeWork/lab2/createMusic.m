function Music= createMusic(D_VECT, NOTE_VECT,START_TIME , fs)
    
    NumOfDuration = length(D_VECT);
    NumOfNote = length(NOTE_VECT);
    
    % avoid the error input%
    if(NumOfDuration == 0)
        return;
    end

    if(NumOfDuration ~= NumOfNote)
        return;
    end

    % find the max duration(s)
    
    MaxDuration = max(START_TIME) + max(D_VECT);
    Finalt = 0 : 1/fs : (MaxDuration - 1 / fs);


    % init the melody
    Music = zeros(size(Finalt));

    % generate the melody
    for i = 1 : 1 : NumOfDuration
        Melody = createNote(D_VECT(i), NOTE_VECT(i), fs);
        d = D_VECT(i); % calculate the total time
        t = 0 : 1/fs : (d - 1 / fs);
        t = t + START_TIME(i);
        Music = AddSeq(Music, Finalt, Melody, t);
    end

end