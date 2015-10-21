function dataOut = insertDrawing(frame, canvas, top, left, memchart)
    %Insert the frame into the canvas at the specified top left location
    %returns dataOut: cell array containing the new canvas and the new
    %memchart
    
    newCanvas = canvas;
    newMemchart = memchart;
    [dim, ~] = size(frame);
    
    for i = 1:3
       newCanvas(top:top+dim-1, left:left+dim-1, i) = frame(:, :, i);
    end
    
    newMemchart(top:top+dim-1, left:left+dim-1) = 1;
    
    dataOut = {newCanvas, newMemchart};
end