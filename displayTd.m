function imageHandle = displayTd(td, colour, axesHandle)
%Assume the T/D size is square matrix
%Display the td onto the axes defined by the axesHandle

    [dim, ~] = size(td);
    alpha = ~td;   %creates the alpha matrix for transparency
    
    lim = [1/(2*dim), 1 - 1/(2*dim)];
    tdDisp = zeros(dim, dim, 3);
    for i = 1:3
       tdDisp(:, :, i) = td;
       c = colour(i);
       for j = 1:dim
           for k = 1:dim
               if td(j, k) == 0
                  tdDisp(j, k, i) = c;
               end
           end
       end
    end
    
    imageHandle = image(lim, lim, tdDisp, 'Parent', axesHandle);
    set(imageHandle, 'AlphaData', alpha);
    colormap('default');
    axis equal;

end