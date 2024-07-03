function [x_reconstructed, o_reconstructed] = denoising_sparse(beta, y, max_iter, g, rho, alpha, tol, dim)

    % Flatten the input data
    original_size = size(y);
    y = y(:); % Flatten to a vector
    total_elements = numel(y);

    x = zeros(total_elements, 1);
    o = zeros(total_elements, 1);
    
    % Create the sparse L matrix
    L = spdiags(ones(total_elements-1, 1), 0, total_elements-1, total_elements) - spdiags(ones(total_elements-1, 1), 1, total_elements-1, total_elements);
    
    function res = gradx(x, o, y, alpha, L)
        res = 2 * (x + o - y) + 2 * alpha * (L' * L) * x;
    end 

    function res = grado(x, o, y)
        res = 2 * (x + o - y);
    end

    function res = objective(x, o, y, alpha, L, beta)
        res = norm((x + o - y), 2)^2 + alpha * norm((L * x), 2)^2 + beta * norm(o, 1);
    end

    k = 1;
    PG = 1000;

    while k <= max_iter && norm(PG, inf) > tol 

        Gamma = HuberHassian(g, o);
        GO = grado(x, o, y);
        PG = PseudoGradiant(GO, o, beta);
        GX = gradx(x, o, y, alpha, L);
        gradient = [GX; PG];
        
        % Create sparse Hessian matrix
        Hessian = [2 * speye(total_elements) + 2 * alpha * (L' * L), 2 * speye(total_elements); 2 * speye(total_elements), 2 * speye(total_elements) + beta * Gamma];
        
        d = - inv(Hessian) * gradient;   
    
        s_o = 1;
        orthant_dir = orthant_direction(GO, o, beta);
        OP = OrthProj(orthant_dir, o, o + s_o * d(total_elements + 1 : 2 * total_elements));
     
        while objective(x, OP, y, alpha, L, beta) > objective(x, o, y, alpha, L, beta) + (1e-4) * gradient(total_elements + 1 : 2 * total_elements)' * (OP - o) 
            s_o = rho * s_o;  
            OP = OrthProj(orthant_dir, o, o + s_o * d(total_elements + 1 : 2 * total_elements));
        end
    
        s_x = 1;

        while objective(x + s_x * d(1 : total_elements), o, y, alpha, L, beta) > objective(x, o, y, alpha, L, beta) + (1e-4) * s_x * gradient(1 : total_elements)' * d(1 : total_elements) 
            s_x = rho * s_x; 
        end
    
        o = OrthProj(orthant_dir, o, o + s_o * d(total_elements + 1 : 2 * total_elements));
        x = x + s_x * d(1 : total_elements);
        
        k = k + 1;
        disp(['number of iterations: ', num2str(k)]);
        disp(['inf norm of l1 part: ', num2str(norm(PG, inf))]);
        disp(['inf norm of f(x) part: ', num2str(norm(GX, inf))]);
    end

    % Reconstruct the data to its original shape
    x_reconstructed = reshape(x, original_size);
    o_reconstructed = reshape(o, original_size);

end