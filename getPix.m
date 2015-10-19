function pix = getPix(coord, dim)
    %Given the coordinate, get the pixel
    %where the resolution is 10x10, and 
    %both x and y axis has limits of 0 to 1
    
    x = coord(1);
    y = coord(2);
    
    xpix = max(1, min(ceil(x*dim), dim));
    ypix = max(1, min(ceil(y*dim), dim));
    
    pix = [ypix xpix];
end