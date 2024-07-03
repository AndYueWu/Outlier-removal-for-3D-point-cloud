function res = HuberHassian(gamma,x)
    n = length(x);
    res = zeros(n,n);
    for i = 1 : n
        if gamma * abs(x) <= 1
            res(i,i) = gamma;
        end
    end
end