function x = OESOM(f,grad, beta, x0, max_iter,g,rho)
    n = length(x0);
    x = x0;
    B = eye(n); 
    for k = 1:max_iter
        Gamma = HuberHassian(g,x);
        PG = PseudoGradiant(gard,x,beta);
        d = - (B + beta * Gamma) \ PG;
        s = BacktrackingLineSearch(f,grad,x,rho,d,beta);
        x_1 = OrthProj(x+s*d);
        delta = x_1 - x;
        y = grad(x_1) - grad(x);
        B = B - ((B * (delta * delta') * B) / (delta' * B * delta)) + ((y * y') / (y' * delta));
        x = x_1;
    end
end