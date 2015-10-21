function imHandle = createStimulus(sHeight, sWidth, dim, targCell, disCell,...
    targC, disC, nCopies, p, minDist, bgColour)
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
    
    %RETURNS: handle to the stimulus image
    
    [~, numTarg] = size(targCell);
    [~, numDis] = size(disCell);
    numPics = numTarg + numDis*nCopies;
    frameDim = dim + 2*minDist;
    minSize = frameDim*numPics;
    
    if minSize > min(sHeight, sWidth)
       imHandle = 0;
       disp('Drawings cannot fit onto the stimulus!\n');
       return;
    end
    
    %To make sure the layout is randomly different each time
    rand('twister', 100*sum(clock));
    
    
    
end