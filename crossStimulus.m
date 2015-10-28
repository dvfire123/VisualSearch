function crossHandle = crossStimulus(height, width, axesHandle)
%Generates a blank stimulus
%with cross in the middle
    stim = zeros(height, width, 3);
    
    %The cross
    hm = floor(height/2);
    wm = floor(width/2);
    stim(hm-2:hm+2, wm, :) = 1;
    stim(hm, wm-2:wm+2, :) = 1;
    
    xl = [1/(2*width), 1 - 1/(2*width)];
    yl = [1/(2*height), 1 - 1/(2*height)];
    
    crossHandle = image(xl, yl, stim, 'parent', axesHandle);
    colormap(axesHandle, 'default');
end

