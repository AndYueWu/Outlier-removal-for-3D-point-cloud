function [x,o] = denoising(beta, y, max_iter,g,rho,alpha,tol)
    
    n = length(y);
    y = y';
    x = zeros(n,1);
    o = zeros(n,1);
    L = [diag(ones(n-1,1)),zeros(n-1,1)] - [zeros(n-1,1),diag(ones(n-1,1))]; %change to spdiag if alogorithm works

    function res = gradx(x,o,y,alpha,L)
        res = 2 * (x + o - y) + 2 * alpha * L' * L * x;
    end 

    function res = grado(x,o,y)
        res = 2 * (x + o - y);
    end

    function res = objective(x,o,y,alpha,L,beta)
        res = norm((x + o - y) , 2)^2 + alpha * norm((L * x), 2)^2 + beta * norm(o,1);
    end

    k = 1;
    PG = 1000;

    while k <= max_iter && norm(PG,inf) > tol  

        Gamma = HuberHassian(g,o);
        GO = grado(x,o,y);
        PG = PseudoGradiant(GO,o,beta);
        GX = gradx(x,o,y,alpha,L);
        gradient = [GX;PG];
        Hassian = [2 * eye(n) + 2 * alpha * L' * L, 2 * eye(n) ; 2 * eye(n) ,2 * eye(n) + beta * Gamma];
        d = - inv(Hassian) * gradient;   
    
        s_o = 1;
        orthant_dir = orthant_direction(GO,o,beta);
        disp(orthant_dir);
        OP = OrthProj(orthant_dir, o, o + s_o * d(n + 1 : 2 * n));
     

        while objective(x,OP,y,alpha,L,beta) > objective(x,o,y,alpha,L,beta) + (1e-4) * gradient(n+1:2*n)' * (OP-o) 
            s_o = rho * s_o;  
            OP = OrthProj(orthant_dir, o,o + s_o * d(n+1:2*n));
        end
    
        s_x = 1;

        while objective(x + s_x * d(1:n),o,y,alpha,L,beta) > objective(x,o,y,alpha,L,beta) + (1e-4) * s_x * gradient(1:n)' * d(1:n) 
            s_x = rho * s_x; 
        end
    
        o = OrthProj(orthant_dir,o,o + s_o * d(n+1:2*n));

        x = x + s_x * d(1:n);
        
        k = k + 1;
        disp(['number of iterations: ', num2str(k)]);
        disp(['inf norm of l1 part: ', num2str(norm(PG, inf))]);
        disp(['inf norm of f(x) part: ', num2str(norm(GX, inf))]);
    end



end