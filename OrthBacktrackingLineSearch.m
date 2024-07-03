function s_k = OrthBacktrackingLineSearch(f, grad, xk,rho,dk,beta)
    s_k = 1;
    OP = OrthProj(grad, x,xk + s_k * dk,beta); 
    while f(OP) + beta * (abs(OP)) > f(xk) + beta * (abs(xk))' + (1e-4) * grad' * (OP -xk)
        s_k = rho * s_k;  
        OP = OrthProj(grad, x,xk + s_k * dk,beta);
    end
end