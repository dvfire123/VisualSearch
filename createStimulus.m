function [res, totalTarg, totalDis] = createStimulus(fullHeight, sHeight, fullWidth, sWidth, dim,...
    targCell, disCell, targC, disC, nCopies, q, minDist, bgColour, axHandle, invTarg)
    %This function generates the stimulus image for the actual test
    
    %INPUTS:
    %fullHeight: height of the stimulus
    %fullWidth: width of the stimulus
    %sHeight: actual height to fit all the drawings
    %sWidth: actual width to fit all the drawings
    %dim: drawing is dim x dim
    %targCell: array of targets
    %disCell: array of distractors
    %targC: colour for the corresponding targets
    %disCell: colour for the corresponding distractors
    %nCopies: no. of copies of each distractor to appear in image
    %p: prob. of target presence
    %minDist: minimum distance of separation between drawings
    %bgColour: background colour of the stimulus
    %axHandle: the axes handle in which to place the stimulus
    
    %RETURNS: whether target 1/2 are in the drawing or not
    MAX_TRIES = 500;
    
    [~, numTarg] = size(targCell);
    [~, numDis] = size(disCell);
    frameSize = dim + 2*minDist;
    sHeight = round(sHeight);
    sWidth = round(sWidth);
    
    %To make sure the layout is randomly different each time
    rand('twister', 100*sum(clock));
    
    %Helper: memory matrix to help us determine whether a drawing is
    %occupying the space or not
    memchart = zeros(fullHeight, fullWidth);
    
    %Create the canvas first
    canvas = ones(fullHeight, fullWidth, 3);
    for i = 1:3
       canvas(:, :, i) = bgColour(i); 
    end
    
    %first let's display the target(s)
    totalTarg = 0;
    totalDis = 0;
    res = 0;
    
    %Count how many targets are there
    for i = 1:numTarg
        targ = targCell{i};
        if isZeroMatrix(targ - ones(dim, dim)) == 0
           totalTarg = totalTarg + 1;
       end
    end
    
    if totalTarg == 1
        p = q;
    else
        p = 1-sqrt(1-q);
    end
    
    for targCount = 1:numTarg
       targ = targCell{targCount};
       
       if isZeroMatrix(targ - ones(dim, dim)) == 1
           %blank drawing is ignored
           continue;
       end
       
       c = targC{targCount};
       
       if invTarg == 1
           targ = flipdim(targ, 1);
       end
       
       if rand < p
          %display the target
          tries = 0;
          found = 1;
          res = 1;  %just need at least 1 target present for res = 1
          
          frame = preProcessDrawing(targ, c, bgColour, minDist);
          insertRangeHeight = sHeight - frameSize + 1;
          insertRangeWidth = sWidth - frameSize + 1;
          top = ceil(rand*insertRangeHeight + floor((fullHeight - sHeight)/2));
          left = ceil(rand*insertRangeWidth + floor((fullWidth - sWidth)/2));
          
          while getFitStatus(memchart, frame, top, left) == 0
             tries = tries + 1;
             if tries >= MAX_TRIES
                 found = 0;
                 break;
             end
             %Selected spot no good; keep searching
             top = ceil(rand*insertRangeHeight);
             left = ceil(rand*insertRangeWidth);
          end
          
          if found == 1
              %We found a good place to place our target:
              dataOut = insertDrawing(frame, canvas, top, left, memchart);

              %Update pic data:
              canvas = dataOut{1};
              memchart = dataOut{2};
          end
       end
    end
    
    %Next let's display the distractors:
    for n = 1:numDis
        dis = disCell{n};
        
        if isZeroMatrix(dis - ones(dim, dim)) == 1
           %blank drawing is ignored
           continue;
        end
        
        c = disC{n};
        totalDis = totalDis + 1;
        
        for k = 1:nCopies
            %We first need to randomly rotate each of the distractors
            if rand < 0.5
                dis = flipdim(dis, 1);
            end
            
            if rand < 0.5
                dis = flipdim(dis, 2);
            end
            
            %Then add the distractor to the canvas
            tries = 0;
            found = 1;
            frame = preProcessDrawing(dis, c, bgColour, minDist);
            insertRangeHeight = sHeight - frameSize + 1;
            insertRangeWidth = sWidth - frameSize + 1;
            top = ceil(rand*insertRangeHeight + floor((fullHeight - sHeight)/2));
            left = ceil(rand*insertRangeWidth + floor((fullWidth - sWidth)/2));

            while getFitStatus(memchart, frame, top, left) == 0
                 tries = tries + 1;
                 if tries >= MAX_TRIES
                     found = 0;
                     break;
                 end
                 
                 %Selected spot no good; keep searching
                 top = ceil(rand*insertRangeHeight);
                 left = ceil(rand*insertRangeWidth);
            end

            if found == 1
                %We found a good place to place our target:
                dataOut = insertDrawing(frame, canvas, top, left, memchart);

                %Update pic data:
                canvas = dataOut{1};
                memchart = dataOut{2};
            end
        end
    end
    
    %Finally we display the canvas in the specified axes handle
    xl = [1/(2*fullWidth), 1 - 1/(2*fullWidth)];
    yl = [1/(2*fullHeight), 1 - 1/(2*fullHeight)];
    
    axes(axHandle);
    hold on;
    image(xl, yl, canvas, 'parent', axHandle);
    colormap(axHandle, 'default');
end