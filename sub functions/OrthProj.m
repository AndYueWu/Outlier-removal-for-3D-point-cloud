function res = OrthProj(orthant_dir,x,y)
    n = length(x);
    res = zeros(n, 1);
    for i = 1:n
        if sign(y(i)) == sign(orthant_dir(i))
            res(i) = y(i);
        end
    end 
end