function imHandle = preProcessDrawing(drawing, colour, bgColour, minDist)
    %Preprocess the drawing: place the drawing in the center of frame
    %of dimension (size of drawing) + minDist x minDist
    
    %drawing has colour info
    %the default white background of the drawing is replaced by the
    %specified bgColour
    
    drawing = flipdim(drawing, 1);
    [dim, ~] = size(drawing);
    frameSize = dim + 2*minDist;
    frame = ones(frameSize, frameSize, 3); %RGB pic
    for i = 1:3
       frame(:, :, i) = bgColour(i); 
    end
    
    for i = minDist+1:frameSize-minDist
        dIndx = i - minDist;
        for j = minDist+1:frameSize-minDist
            dIndy = j - minDist;
            
            if drawing(dIndx, dIndy) ~= 1
               %Not part of the background, thus restore colour
               for k = 1:3
                  frame(i, j, k) = colour(k); 
               end
            end
        end
    end
    
    %Test
    figure;
    imHandle = image(frame);
end