function pseudo_grad = PseudoGradiant(grad,x,beta)
    n = length(x);
    pseudo_grad = zeros(n, 1);
    for i = 1:n
        if x(i) ~= 0
            pseudo_grad(i) = grad(i) + beta * sign(x(i));
        elseif x(i) == 0 && grad(i) < -beta
            pseudo_grad(i) = grad(i) + beta;
        elseif x(i) == 0 && grad(i) > beta
            pseudo_grad(i) = grad(i) - beta;
        else
            pseudo_grad(i) = 0;
        end
    end
end
