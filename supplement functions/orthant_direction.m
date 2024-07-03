function res = orthant_direction(grad,x,beta)
    n = length(x);
    res = zeros(n,1);
    for i = 1:n
        if x(i) ~= 0
            res(i) = sign(x(i));
        elseif x(i) == 0 && grad(i) < - beta
            res(i) = 1;
        elseif x(i) == 0 && grad(i) > beta
            res(i) = -1;
        else
            res(i) = 0;
        end
    end
end