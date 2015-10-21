function canFit = getFitStatus(memchart, drawing, leftx, lefty)
    %Test if the drawing can fit the found space
    %given proposed top left corner for drawing
    %Assume the drawing won't go out of bounds
    
    [dim, ~] = size(drawing);
    crop = memchart(leftx:leftx+dim-1, lefty:lefty+dim-1);
    if all(~any(crop))
       canFit = 1;
    else
       canFit = 0;
    end
end