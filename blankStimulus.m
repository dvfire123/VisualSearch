function bhandle = blankStimulus(height, width, axesHandle)
%Generates a blank stimulus
    stim = ones(height, width, 3);
    
    xl = [1/(2*width), 1 - 1/(2*width)];
    yl = [1/(2*height), 1 - 1/(2*height)];
    
    bhandle = image(xl, yl, stim, 'parent', axesHandle);
    colormap('default');
end

