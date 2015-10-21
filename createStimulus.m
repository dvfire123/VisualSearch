function imHandle = createStimulus(sHeight, sWidth, dim, targCell, disCell,...
    targC, disC, nCopies, p, minDist, bgColour, axHandle)
    %This function generates the stimulus image for the actual test
    
    %INPUTS:
    %sHeight: height of the stimulus
    %sWidth: width of the stimulus
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
    
    %RETURNS: handle to the stimulus image
    MAX_TRIES = 1000;
    tries = 0;
    
    [~, numTarg] = size(targCell);
    [~, numDis] = size(disCell);
    numPics = numTarg + numDis*nCopies;
    frameSize = dim + 2*minDist;
    minSize = frameSize*frameSize*numPics;
    
    if minSize > sHeight*sWidth
       imHandle = 0;
       disp('Drawings cannot fit onto the stimulus!\n');
       return;
    end
    
    %To make sure the layout is randomly different each time
    rand('twister', 100*sum(clock));
    
    %Helper: memory matrix to help us determine whether a drawing is
    %occupying the space or not
    memchart = zeros(sHeight, sWidth);
    
    %Create the canvas first
    canvas = ones(sHeight, sWidth, 3);
    for i = 1:3
       canvas(:, :, i) = bgColour(i); 
    end
    
    %first let's display the target(s)
    targCount = 0;
    while targCount < numTarg
       targCount = targCount + 1;
       targ = targCell{targCount};
       c = targC{targCount};
       
       if rand < p
          %display the target
          tries = 0;
          found = 1;
          frame = preProcessDrawing(targ, c, bgColour, minDist);
          insertRangeHeight = sHeight - frameSize + 1;
          insertRangeWidth = sWidth - frameSize + 1;
          top = ceil(rand*insertRangeHeight);
          left = ceil(rand*insertRangeWidth);
          
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
        c = disC{n};
        
        for k = 1:nCopies
            %We first need to randomly rotate each of the distractors
            if rand < 0.5
                flipdim(dis, 1);
            end
            
            if rand < 0.5
                flipdim(dis, 2);
            end
            
            %Then add the distractor to the canvas
            tries = 0;
            found = 1;
            frame = preProcessDrawing(dis, c, bgColour, minDist);
            insertRangeHeight = sHeight - frameSize + 1;
            insertRangeWidth = sWidth - frameSize + 1;
            top = ceil(rand*insertRangeHeight);
            left = ceil(rand*insertRangeWidth);

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
    lim = [1/(2*sHeight), 1 - 1/(2*sWidth)];
    imHandle = image(lim, lim, canvas, 'Parent', axHandle);
    colormap('default');
    axis equal;
end