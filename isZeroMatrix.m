function res = isZeroMatrix(M)
    %Tests if matrix M is zero or not
    res = all(~any(M));
end