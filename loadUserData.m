function outArr = loadUserData(file)
    %Reads the user data and stores the inputs in an array
    %called "outArr"
    
    fid = fopen(file, 'r');
    if fid == -1
       outArr = [];
       return;
    end
    numLines = 0;
    
    tline = fgetl(fid);
    while ischar(tline)
        numLines = numLines+1;
        tline = fgetl(fid);
    end

    fclose(fid);
    
    if numLines == 0
        return;
    end
    
    %Now populate the output array
    outArr = cell(numLines, 1);
    fid = fopen(file, 'r');    
    tline = fgetl(fid);
    c = 1;
    
    while ischar(tline)
        outArr{c} = tline;
        c = c+1;
        tline = fgetl(fid);
    end

    fclose(fid);
end